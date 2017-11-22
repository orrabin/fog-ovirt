module Fog
  module Compute
    class Ovirt
      class Real
        def destroy_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for destroy-volume" unless options.key? :id

          disks_service = connection.system_service.disks_service
          disks_service.disk_service(options[:id]).remove
        end
      end

      class Mock
        def destroy_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for destroy-volume" unless options.key? :id
          true
        end
      end
    end
  end
end
