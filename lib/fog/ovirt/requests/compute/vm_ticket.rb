module Fog
  module Compute
    class Ovirt
      class Real
        def vm_ticket(id, options = {})
          connection.system_service.vms_service.vm_service(id).ticket(options)
        end
      end

      class Mock
        def vm_ticket(id, options = {})
          "Secret"
        end
      end
    end
  end
end
