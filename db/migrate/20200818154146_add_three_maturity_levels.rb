class AddThreeMaturityLevels < ActiveRecord::Migration[5.2]
  def change
    MaturityLevel.create!({
      name: 'Emerging',
      position: 1,
      definition: 'This practice is emerging and worth watching as it is being assessed in early implementations.'
    })
    MaturityLevel.create!({
      name: 'Replicating',
      position: 2,
      definition: 'This practice is replicating across multiple facilities as its impact continues to be validated.'
    })
    MaturityLevel.create!({
      name: 'Scaling',
      position: 3,
      definition: 'This practice is scaling widely with the support of national stakeholders.'
    })
  end
end
