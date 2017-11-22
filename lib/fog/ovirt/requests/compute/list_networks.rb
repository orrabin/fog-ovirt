module Fog
  module Compute
    class Ovirt
      class Real
        def list_networks(cluster_id)
          connection.system_service.clusters_service.cluster_service(cluster_id).networks_service.list
        end
      end
      class Mock
        def list_networks(cluster_id)
          []
        end
      end
    end
  end
end
