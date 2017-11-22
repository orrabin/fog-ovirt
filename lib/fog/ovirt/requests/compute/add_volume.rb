module Fog
  module Compute
    class Ovirt
      class Real
        DISK_SIZE_TO_GB = 1073741824
        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          search = options[:search] || ("datacenter=%s" % datacenter)
          options[:bootable] = 'true' unless options[:bootable]
          options[:interface] = 'virtio' unless options[:interface].present?
          options[:provisioned_size]=options[:size_gb].to_i*DISK_SIZE_TO_GB if options[:size_gb]

          options[:storage_domain_id] = options[:storage_domain] || storagedomains(:role => 'data', :search => search).first.id
          # If no size is given, default to a volume size of 8GB
          options[:provisioned_size] = 8 * 1024 * 1024 * 1024 unless options[:provisioned_size]
          options[:type] = 'data' unless options[:type]
          options[:format] = 'cow' unless options[:format]
          options[:sparse] = true unless options[:sparse].present?

          options[:disk] ||= {}
          options[:disk][:storage_domains] ||= [connection.system_service.storage_domains_service.storage_domain_service(options[:storage_domain_id]).get]
          options[:disk][:provisioned_size] ||= options.delete(:provisioned_size)
          options[:disk][:type] ||= options.delete(:type)
          options[:disk][:format] ||= options.delete(:format)
          options[:disk][:sparse] ||= options.delete(:sparse)

          disk_attachments_service = connection.system_service.vms_service.vm_service(id).disk_attachments_service
          disk = OvirtSDK4::DiskAttachment.new(options)
          disk_attachments_service.add(disk)
        end
      end

      class Mock
        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          true
        end
      end
    end
  end
end
