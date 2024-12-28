class CreateWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :weeks do |t|
      t.string :name  #名前
      t.string :tel #電話番号
      t.string :email #メールアドレス
      t.string :postnumber #郵便番号
      t.string :address #住所
      t.string :people #屋内の場合、使用が想定される人数
      t.date :check_in_date #設置箇所
      t.date :check_out_date
      t.string :remarks #要望
      t.timestamps
    end
  end
end
