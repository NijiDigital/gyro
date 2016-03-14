module DBGenerator

  describe XCDataModel do

    it 'check raise an error for file' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/not_found.xcdatamodel', File.dirname(__FILE__))
      expect { XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir) }.to raise_error "\e[1;31m! Unable to find contents of xcdatamodel dir\e[0m"
    end

    it 'check raising relationship error' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/error_relationship.xcdatamodel', File.dirname(__FILE__))
      expect { XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir) }.to raise_error "\e[1;31m! The relationship \"user\" from \"RLMFidelityCard\" is wrong - please fix it\e[0m"
    end

    it 'check raising undefined type error' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/error_undefined_type.xcdatamodel', File.dirname(__FILE__))
      expect { XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir) }.to raise_error "\e[1;31m! The attribute \"name\" from \"RLMProduct\" has no type - please fix it\e[0m"
    end

    it 'check raising enum type error' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/error_enum_type.xcdatamodel', File.dirname(__FILE__))
      expect { XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir) }.to raise_error "\e[1;31m! The attribute \"type\" from \"RLMShop\" is enum with incorrect type (not Integer) - please fix it\e[0m"
    end

    it 'check abstract entity' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/entity.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.name).to eq 'DBAnimal'
      expect(entity.parent).to eq ''
      expect(entity.abstract?).to be true
    end

    it 'check attribute' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/entity.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.attributes.length).to eq 1
      attribute = entity.attributes.values.first
      expect(attribute.name).to eq 'animal'
      expect(attribute.optional?).to be true
      expect(attribute.default).to eq 'animalDefault'
    end

    it 'check relationship' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/relationship.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 2
      entity_1, entity_2 = xcdatamodel.entities.values
      relationship = entity_1.relationships.values.first
      relationship_inverse = entity_2.relationships.values.first
      expect(relationship.inverse_name).to eq(relationship_inverse.name)
      expect(relationship_inverse.inverse_name).to eq(relationship.name)
    end

    it 'check relationship without destination' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/relationship_type.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.relationships.length).to eq 1
      relationship = entity.relationships.values.first
      expect(relationship.name).to eq 'relationshipNoValue'
      expect(relationship.destination).to_not be_empty
      expect(relationship.type).to eq :to_many
    end

    it 'check global xcdatamodel' do
      xcdatamodel_dir = File.expand_path('../fixtures/xcdatamodel/global.xcdatamodel', File.dirname(__FILE__))
      xcdatamodel = XCDataModel::Parser::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 6
    end

  end
end
