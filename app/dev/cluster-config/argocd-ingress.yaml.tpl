# Exposes your Argo CD service to the internet via ALB.
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    # ALB config
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'

    # ACM certificate
    alb.ingress.kubernetes.io/certificate-arn: ${ACM_CERT_ARN}

    # Redirect all HTTP to HTTPS
    alb.ingress.kubernetes.io/actions.redirect-to-https: >
      {"Type":"redirect","RedirectConfig":{"Protocol":"HTTPS","Port":"443","StatusCode":"HTTP_301"}}

    # ExternalDNS will create/update Route53 record
    external-dns.alpha.kubernetes.io/hostname: argocd-dev.hellosaanvika.com
spec:
  rules:
  - host: argocd-dev.hellosaanvika.com
    http:
      paths:
      # Redirect HTTP -> HTTPS
      - path: /
        pathType: Prefix
        backend:
          service:
            name: redirect-to-https
            port:
              name: use-annotation
      # Actual ArgoCD backend
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 443
