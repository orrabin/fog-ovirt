module Fog
  module Compute
    class Ovirt
      class Real
        def datacenters filter={}
          connection.system_service.data_centers_service.list(filter).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end

        class Mock
        def datacenters(filters = {})
          xml = read_xml 'data_centers.xml'
          Nokogiri::XML(xml).xpath('/data_centers/data_center').map do |dc|
            ovirt_attrs OvirtSDK4::Reader.read(dc.to_s)
          end
        end
      end
    end
  end
end
