# UseCase Architecture

# Context Map

# Tasks
## Contract
- [ ] NFT作成コントラクト（NFTCreatorContract）
  - NFTをミントする関数を実装する
  - メタデータ作成をトリガーするイベント発行関数を実装する
## Operator
- [ ] メタデータの作成と保存（NFTMetadataCreator）
  - NFTCreatorContractからのイベントを受信してメタデータを作成
  - 作成したメタデータをPrisma等を使ってDBに保存
## User
- [ ] CLIからのコントラクトコール
  - NFTCreatorContractをコールしてNFTをミント
  - HTTPコールでNFTMetadataServerにアクセスし、メタデータを取得
## Scope外
- [ ] メタデータ検証ロジック