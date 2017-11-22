module Fog
  module Compute
    class Ovirt
      class Real
        def list_template_volumes(template_id)
         # disk_attachments_service = connection.system_service.templates_service.template_service(template_id).disk_attachments_service
         # disk_attachments_service.list.map {|ovirt_obj| ovirt_attrs connection.system_service.disks_service.disk_service(ovirt_obj.id).get}

          template = connection.system_service.templates_service.template_service(template_id).get

          attachments = connection.follow_link(template.disk_attachments)

          attachments.map do |attachment|
            ovirt_attrs connection.follow_link(attachment.disk)
          end
        end
      end
      class Mock
        def list_template_volumes(template_id)
          xml = read_xml 'volumes.xml'
          Nokogiri::XML(xml).xpath('/disks/disk').map do |vol|
            ovirt_attrs OvirtSDK4::Reader.read(vol.to_s)
          end
        end
      end
    end
  end
end
