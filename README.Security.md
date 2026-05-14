# 🛡️ Guia de Segurança e Governança (DevSecOps)

Este documento detalha o fluxo de integridade e segurança aplicado ao projeto **Project Calculator**. Seguimos o princípio de "Zero Trust" para artefatos de software, garantindo que apenas imagens verificadas, escaneadas e assinadas possam ser executadas em nossos ambientes.

---

## 🏗️ Ciclo de Confiança do Artefato

O projeto implementa uma cadeia de custódia composta por três pilares fundamentais:

1. **Scan de Vulnerabilidades (Static Analysis)**
2. **Assinatura Digital (Provenance & Integrity)**
3. **Admissão por Política (Enforcement)**

---

## 1. 🛡️ Scan de Vulnerabilidades com Trivy

Antes de qualquer imagem ser considerada para produção, ela deve passar por um scan completo de CVEs (Common Vulnerabilities and Exposures).

**Comando para análise local:**
```bash
trivy image --severity CRITICAL,HIGH afmaia/projeto-calculadora:v1.0.0
```
*Nosso critério de aceitação bloqueia qualquer build que contenha vulnerabilidades de nível CRITICAL.*

---

## 2. ✍️ Assinatura Digital com Cosign

Utilizamos o **Sigstore Cosign** para assinar nossas imagens. Isso garante que a imagem que está no registro é exatamente a que foi aprovada no pipeline, sem alterações de terceiros.

### Verificar a Assinatura (Manual)
Qualquer usuário pode validar a integridade da imagem utilizando nossa chave pública:

```bash
cosign verify --key keys/cosign.pub afmaia/projeto-calculadora:v1.0.0
```

### Fluxo de Assinatura (Mantenedores)
```bash
# Assinando a imagem após aprovação nos testes
cosign sign --key keys/cosign.key afmaia/projeto-calculadora:v1.0.0
```

---

## 3. ⚙️ Implementação do Cosign Admission Controller

Para garantir a governança nativa, utilizamos o **Cosign Admission Controller** (parte do projeto Sigstore Policy Controller). Ele atua como um Webhook de admissão que valida as assinaturas diretamente na API do Kubernetes.

### Como Instalar (via Helm)
```bash
# Adicionar o repositório Sigstore
helm repo add sigstore https://sigstore.github.io/helm-charts
helm repo update

# Instalar o Policy Controller
helm install policy-controller sigstore/policy-controller -n cosign-system --create-namespace
```

### Ativação no Namespace
Para que o controlador monitore um namespace específico, adicione a label:
```bash
kubectl label namespace default policy.sigstore.dev/include=true
```

---

## ⚖️ Configuração de Política (ClusterImagePolicy)

O recurso `ClusterImagePolicy` define as regras de confiança para o cluster. Abaixo, a configuração para exigir assinaturas em todas as imagens do repositório da calculadora.

```yaml
apiVersion: policy.sigstore.dev/v1alpha1
kind: ClusterImagePolicy
metadata:
  name: calculadora-signature-policy
spec:
  images:
    - glob: "index.docker.io/afmaia/projeto-calculadora:*"
  authorities:
    - key:
        data: |
          -----BEGIN PUBLIC KEY-----
          # Conteúdo da sua chave keys/cosign.pub
          MCowBQYDK2VwAyEAX... (sua_chave_aqui)
          -----END PUBLIC KEY-----
```

**Comportamento do Controller:**
1. **Verificação:** Ao tentar subir um Pod, o controller busca o artefato `.sig` no registro.
2. **Criptografia:** Valida a assinatura contra a chave pública declarada acima.
3. **Bloqueio:** Se a assinatura não for válida ou não existir, a criação do Pod é rejeitada com erro de admissão.

---

## 🎯 Benefícios deste Fluxo

*   **Nativo do Ecossistema Sigstore:** Integração perfeita entre a ferramenta de assinatura (Cosign) e o controlador de admissão.
*   **Segurança Determinística:** Impede a execução de qualquer imagem não assinada ou alterada após o build.
*   **Conformidade como Código:** Políticas declarativas que podem ser versionadas e auditadas.

---
*Este projeto segue as melhores práticas de Software Supply Chain Security (SLSA).*
