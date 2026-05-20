# Identificação
**Aluno:** Kaio Cesar de Sousa Pinheiro
**Disciplina:** DIM0524 - Desenvolvimento de Sistemas para Dispositivos Móveis
**Instituição:** Universidade Federal do Rio Grande do Norte (UFRN)

---

# Loja Online - Projeto Completo (Etapas 1 a 4)

## Sobre
Projeto Flutter de e-commerce simulado — 2ª unidade avaliativa (versão completa).

## Etapas cobertas
| Etapa | O que foi implementado |
|-------|------------------------|
| **Etapa 1** | Layout visual da tela de login |
| **Etapa 2** | Validação, navegação, widget ProductCard com parâmetros |
| **Etapa 3** | `async`/`await`, requisições HTTP à `fakestoreapi.com`, serialização JSON, persistência de sessão com `SharedPreferences` |
| **Etapa 4** | Carrinho de compras com `setState`, ajuste de quantidade, remoção de itens, total calculado dinamicamente |

## Estrutura do projeto
```
lib/
├── main.dart                         # Verificação de sessão (Etapa 3)
├── models/
│   ├── product.dart                  # Product.fromJson (Etapa 3)
│   └── cart_item.dart                # CartItem com quantidade (Etapa 4)
├── screens/
│   ├── login_screen.dart             # Login via API (Etapa 3)
│   ├── product_list_screen.dart      # Produtos da API + carrinho (Etapas 3-4)
│   └── cart_screen.dart             # Tela do carrinho (Etapa 4)
├── services/
│   ├── api_service.dart              # HTTP/JSON (Etapa 3)
│   └── auth_service.dart            # SharedPreferences (Etapa 3)
└── widgets/
    └── product_card.dart             # Widget com imagem real da API
```

## Como executar
```bash
# Instalar dependências (http + shared_preferences)
flutter pub get

# Executar no dispositivo/emulador
flutter run

# Verificar erros
flutter analyze
```

## Credenciais de teste (fakestoreapi.com)
A API usa usuários pré-cadastrados. Use qualquer um da lista:
| Usuário | Senha |
|---------|-------|
| `mor_2314` | `83r5^_` |
| `johnd` | `m38rmF$` |
| `kevinryan` | `kev02937@` |

> Fonte: https://fakestoreapi.com/users

## Observações técnicas
- **Persistência:** após login bem-sucedido, o token é salvo com `SharedPreferences`. Ao reabrir o app, o `AuthGate` detecta a sessão e vai direto para a tela de produtos.
- **Carrinho:** gerenciado em memória com `setState` e passado entre telas via parâmetro/callback.
- **Tratamento de erros:** timeouts e falhas de rede exibem mensagem e botão de retry.

## Requisitos
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Conexão com internet (para a API)
