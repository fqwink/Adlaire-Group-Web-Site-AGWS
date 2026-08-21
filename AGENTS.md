# AGENTS.md

## 作業開始時の必須確認

- すべての作業開始時に、必ずこの `AGENTS.md` を読むこと。
- このリポジトリは `Adlaire-Group-Web-Site-AGWS` の開発正本として扱うこと。
- `adlaire.com` の公開面デザイン・構成の参照元として扱うこと。
- デザイン方針の上位参照は、`Adlaire-Design/Docs/Brand_Color_Spec` および `Adlaire-Design/Docs/AGWS_Design_Analysis` とする。
- 変更履歴は `CHANGELOG.md`、プロジェクト説明は `README.md` を正本として扱うこと。

## リポジトリ構成

- `index.html`: トップページ
- `about.html`: 組織概要ページ
- `contact.html`: お問い合わせページ
- `legal.html`: 法的情報ページ
- `architect.css`: Architect CSSフレームワーク
- `style.css`: サイト固有スタイル
- `Tools/check/`: AGWS専用の検査シェル
- `README.md`: プロジェクト説明
- `CHANGELOG.md`: 変更履歴

## 基本方針

- 現行の静的HTML構成を尊重すること。
- Ver.0.6系では、JavaScriptに依存しないCSSベース実装を維持すること。
- `architect.css` はフレームワーク層、`style.css` はサイト固有層として扱うこと。
- `index.html`、`about.html`、`contact.html`、`legal.html` の共通構成を不用意に崩さないこと。
- 2カラム構成、レスポンシブ対応、パンくず、サイドバー、カード、CSS onlyタブ、タイムラインを公開面デザインの重要要素として扱うこと。
- Node.js/npm依存物(`package.json`、`package-lock.json`、`node_modules`)を追加しないこと。
- AGWS専用の検査シェルは `Tools/check/` で管理すること。
