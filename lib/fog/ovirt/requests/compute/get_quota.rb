module Fog
  module Compute
    class Ovirt
      class Real
        def get_quota(id)
          ovirt_attrs system_service.data_centers_service.data_center_service(datacenter).quotas_service.quota_service(id).get
        end
      end
      class Mock
        def get_quota(id)
          xml = read_xml('quota.xml')
          ovirt_attrs OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
