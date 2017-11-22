module Fog
  module Compute
    class Ovirt
      class Real
        def add_interface(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          vm = connection.system_service.vms_service.vm_service(id)
          nics_service = vm.nics_service

          if options[:network].present?
            network = connection.system_service.networks_service.network_service(options[:network]).get
            profiles = connection.follow_link(network.vnic_profiles)

            profile = profiles.detect { |x| x.name == network.name }
            unless profile
              profile = profiles.sort_by { |x| x.name }.first
            end

            options.delete(:network)
            options[:vnic_profile] = {id: profile.id}
          end

          interface = OvirtSDK4::Nic.new(options)
          nics_service.add(interface)
        end
      end

      class Mock
        def add_interface(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          true
        end
      end
    end
  end
end
