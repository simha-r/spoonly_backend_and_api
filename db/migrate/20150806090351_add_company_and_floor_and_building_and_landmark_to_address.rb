class AddCompanyAndFloorAndBuildingAndLandmarkToAddress < ActiveRecord::Migration
  def change
    add_column :addresses,:company,:string
    add_column :addresses,:floor,:string
    add_column :addresses,:building,:string
    add_column :addresses,:flat,:string
    add_column :addresses,:landmark,:string
    add_column :addresses,:address,:string
    add_column :addresses,:default,:boolean
    remove_column :addresses,:name
  end
end
