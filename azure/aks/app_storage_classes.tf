# resource "kubectl_manifest" "storage_class" {
#   for_each = var.cluster_created ? local.storage_classes : {}

#   yaml_body = <<YAML
# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: ${each.key}
#   namespace: ${each.value}
#   annotations:
#     storageclass.kubernetes.io/is-default-class: "false"
# provisioner: file.csi.azure.com
# volumeBindingMode: WaitForFirstConsumer 
# reclaimPolicy: Delete
# allowVolumeExpansion: true
# mountOptions:
#  - dir_mode=0777
#  - file_mode=0777
#  - uid=0
#  - gid=0
#  - mfsymlinks
#  - cache=strict
#  - actimeo=30
# parameters:
#   skuName: Standard_ZRS
#   shareName: ${each.key}
# YAML

#   depends_on = [
#     kubernetes_namespace.elk
#   ]
# }
