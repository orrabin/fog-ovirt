module Fog
  module Compute
    class Ovirt
      class Real
        def list_instance_types(filters = {})
          connection.system_service.instance_types_service.list(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_instance_types(filters = {})
          xml = read_xml 'instance_types.xml'
          Nokogiri::XML(xml).xpath('/instance_types/instance_type').map do |t|
            ovirt_attrs OvirtSDK4::Reader.read(t.to_s)
          end
        end
      end
    end
  end
end
