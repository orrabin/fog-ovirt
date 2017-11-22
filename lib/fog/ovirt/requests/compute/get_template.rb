module Fog
  module Compute
    class Ovirt
      class Real
        def get_template(id)
          ovirt_attrs connection.system_service.templates_service.template_service(id).get
        end
      end
      class Mock
        def get_template(id)
          xml = read_xml 'template.xml'
          ovirt_attrs OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
