class AddColumnToEstimate < ActiveRecord::Migration[5.2]
  def change
    add_column :estimates, :choice, :string   # プラン選択
    add_column :estimates, :company, :string  # 会社名
    add_column :estimates, :url, :string      # URL
  end
end
