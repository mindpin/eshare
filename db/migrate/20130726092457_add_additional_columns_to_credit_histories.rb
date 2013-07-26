# -*- coding: utf-8 -*-
class AddAdditionalColumnsToCreditHistories < ActiveRecord::Migration
  def change
    change_table(:credit_histories) do |t|
      t.integer :real   #实际增减
      t.integer :before
      t.integer :after
      t.integer :canceled_id
    end
  end
end
