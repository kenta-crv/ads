class CreateWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :workers do |t|
      t.string :first_name #苗字
      t.string :last_name #名前
      t.string :first_kana #ミョウジ
      t.string :last_kana #ナマエ
      t.string :tel #電話番号
      t.string :mail #メールアドレス
      t.string :postnumber #郵便番号
      t.string :address #住所
      t.string :experience #経験
      t.string :item #商材名
      t.string :ago #経験年数
      t.string :worktime #週稼働時間
      t.string :agree #約款同意

      t.string :data #音声データ

      t.string :bank #銀行名
      t.string :store #支店
      t.string :account_number #口座番号
      t.string :transfer_name #振込名義

      t.string :other_1
      t.string :other_2
      t.string :other_3
      t.string :other_4
      t.string :other_5

      t.string :comment
      t.timestamps
    end
  end
end
