# Exposes your Argo CD service to the internet via ALB.
# Uses the TLS certificate from cert-manager for HTTPS.

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:  # Tells Kubernetes to use the ALB Ingress controller and cert-manager.
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: ${ACM_CERT_ARN}

spec:
  rules:  #  Maps the domain to your Argo CD service.
  - host: argocd.hellosaanvika.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 80

# This will create an ALB that listens on 80/443, uses the TLS cert from argocd-tls, and routes traffic to your Argo CD service.
