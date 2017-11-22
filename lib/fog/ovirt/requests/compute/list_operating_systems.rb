module Fog
  module Compute
    class Ovirt
      class Real
        def list_operating_systems
          connection.system_service.operating_systems_service.list.map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_operating_systems
          xml = read_xml 'operating_systems.xml'
          Nokogiri::XML(xml).xpath('/operating_systems/operating_system').map do |os|
            ovirt_attrs OvirtSDK4::Reader.read(os.to_s)
          end
        end
      end
    end
  end
end
