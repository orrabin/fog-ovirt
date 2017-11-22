module Fog
  module Compute
    class Ovirt
      class Real
        def destroy_vm(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id

          connection.system_service.vms_service.vm_service(options[:id]).remove
        end
      end

      class Mock
        def destroy_vm(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          true
        end
      end
    end
  end
end
