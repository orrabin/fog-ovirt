module Fog
  module Compute
    class Ovirt
      class Real
        def process_vm_opts(opts)
          if (opts[:template] or opts[:template_name]) and (opts[:storagedomain] or opts[:storagedomain_name])
            template_id = opts[:template] || connection.system_service.templates_service.search(:name => opts[:template_name]).first.id
            template_disks = connection.system_service.templates_service.template_service(template_id).get.disk_attachments
            storagedomain_id = opts[:storagedomain] || storagedomains.select{|s| s.name == opts[:storagedomain_name]}.first.id

            # Make sure the 'clone' option is set if any of the disks defined by
            # the template is stored on a different storage domain than requested
            opts[:clone] = true unless opts[:clone] == true || template_disks.empty? || template_disks.all? { |d| d.storage_domain == storagedomain_id }

            # Create disks map
            opts[:disks] = template_disks.collect { |d| {:id => d.id, :storagedomain => storagedomain_id} }
          end
        end

        def create_vm(attrs)
          attrs[:cluster_name] ||= datacenter.clusters.first.name unless attrs[:cluster]
          vms_service = connection.system_service.vms_service
          attrs[:cluster] = connection.system_service.clusters_service.cluster_service(attrs[:cluster]).get
          attrs[:instance_type] = attrs[:instance_type].present? ?
                                      connection.system_service.instance_types_service.instance_type_service(attrs[:instance_type]).get : nil
          attrs[:template] = attrs[:template].present? ?
                                 connection.system_service.templates_service.template_service(attrs[:template]).get : nil
          attrs[:comment] ||= ''

          # TODO: handle cloning from template
          process_vm_opts(attrs)


          new_vm = OvirtSDK4::Vm.new(attrs)
          vms_service.add(new_vm)
        end
      end

      class Mock
        def create_vm(attrs)
          xml = read_xml('vm.xml')
          OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
