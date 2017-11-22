module Fog
  module Compute
    class Ovirt
      class Real
        def list_quotas(filters = {})
          system_service.data_centers_service.data_center_service(datacenter).quotas_service.list(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_quotas(filters = {})
          xml = read_xml 'quotas.xml'
          Nokogiri::XML(xml).xpath('/quotas/quota').map do |q|
            ovirt_attrs OvirtSDK4::Reader.read(q.to_s)
          end
        end
      end
    end
  end
end
