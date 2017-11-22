module Fog
  module Compute
    class Ovirt
      class Real
        def get_cluster(id)
          ovirt_attrs connection.system_service.clusters_service.cluster_service(id).get
        end
      end
      class Mock
        def get_cluster(id)
          xml = read_xml('cluster.xml')
          ovirt_attrs OvirtSDK4::Reader.read(Nokogiri::XML(xml).root.to_s)
        end
      end
    end
  end
end
