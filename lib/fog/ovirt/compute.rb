require 'fog/ovirt/core'

module Fog
  module Compute
    class Ovirt < Fog::Service
      requires   :ovirt_username, :ovirt_password
      recognizes :ovirt_url,      :ovirt_server,  :ovirt_port, :ovirt_api_path, :ovirt_datacenter,
                 :ovirt_filtered_api,
                 :ovirt_ca_cert_store, :ovirt_ca_cert_file, :ovirt_ca_no_verify

      model_path 'fog/ovirt/models/compute'
      model      :server
      collection :servers
      model      :template
      collection :templates
      model      :instance_type
      collection :instance_types
      model      :cluster
      collection :clusters
      model      :interface
      collection :interfaces
      model      :operating_system
      collection :operating_systems
      model      :volume
      collection :volumes
      model      :quota
      collection :quotas
      model      :affinity_group
      collection :affinity_groups

      request_path 'fog/ovirt/requests/compute'

      request :vm_action
      request :vm_start_with_cloudinit
      request :destroy_vm
      request :create_vm
      request :update_vm
      request :datacenters
      request :storage_domains
      request :list_virtual_machines
      request :get_virtual_machine
      request :list_templates
      request :get_template
      request :list_instance_types
      request :get_instance_type
      request :list_clusters
      request :get_cluster
      request :add_interface
      request :destroy_interface
      request :update_interface
      request :list_vm_interfaces
      request :list_template_interfaces
      request :list_networks
      request :vm_ticket
      request :list_vm_volumes
      request :list_template_volumes
      request :list_volumes
      request :add_volume
      request :destroy_volume
      request :update_volume
      request :attach_volume
      request :detach_volume
      request :activate_volume
      request :deactivate_volume
      request :get_api_version
      request :list_quotas
      request :get_quota
      request :list_affinity_groups
      request :get_affinity_group
      request :list_affinity_group_vms
      request :create_affinity_group
      request :destroy_affinity_group
      request :add_to_affinity_group
      request :remove_from_affinity_group
      request :list_operating_systems

      module Shared
        # converts an OVIRT object into an hash for fog to consume.
        def ovirt_attrs obj
          opts = {:raw => obj}
          obj.instance_variables.each do |v|
            key = v.to_s.gsub("@","").to_sym
            value = obj.instance_variable_get(v)

            if key == :network
              opts[key] = connection.follow_link(obj.vnic_profile).network.id
              next
            end

            #ignore nil values
            next if value.nil?

            if value.respond_to?(:href) && value.href && value.respond_to?(:id)
              opts[key] = value.id
            end

            opts[key] ||= case value
                          when OvirtSDK4::TemplateVersion, Array, Hash, OvirtSDK4::List, OvirtSDK4::Display
                            value
                          when OvirtSDK4::Cpu
                            opts[:cores] = value.try(:topology).try(:cores)
                          else
                            value.to_s.strip
                          end
          end
          opts
        end
      end

      class Mock
        include Shared

        def initialize(options={})
          #require 'rbovirt'
          require 'ovirtsdk4'
        end

        private

        def connection
          return @connection if defined?(@connection)
        end

        #read mocks xml
        def read_xml(file_name)
          file_path = File.join(File.dirname(__FILE__),"requests","compute","mock_files",file_name)
          File.read(file_path)
        end
      end

      class Real
        include Shared

        def initialize(options={})
          #require 'rbovirt'
          require 'ovirtsdk4'
          username   = options[:ovirt_username]
          password   = options[:ovirt_password]
          server     = options[:ovirt_server]
          port       = options[:ovirt_port]       || 8080
          api_path   = options[:ovirt_api_path]   || '/api'
          url        = options[:ovirt_url]        || "#{@scheme}://#{server}:#{port}#{api_path}"

          connection_opts = {
              :url      => url,
              :username => username,
              :password => password,
          }

          @datacenter = options[:ovirt_datacenter]
          connection_opts[:ca_file]  = options[:ca_file]
          connection_opts[:ca_certs] = [OpenSSL::X509::Certificate.new(options.delete(:public_key))] if options[:public_key].present?

          @connection = OvirtSDK4::Connection.new(connection_opts)
        end

        def api_version
          api = connection.system_service.get
          api.product_info.version.full_version
        end

        def datacenter
          @datacenter
        end

        private

        def connection
          @connection
        end
      end
    end
  end
end
