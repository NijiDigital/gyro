# Copyright 2016 - Niji
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Gyro
  describe Parser::XCDataModel do
    before do
      Gyro::Log.quiet = true
    end

    it 'check raise an error for file' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'not_found.xcdatamodel'
      expect { Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir) }
        .to raise_error 'Unable to find contents of xcdatamodel'
    end

    it 'check raising relationship error' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'error_relationship.xcdatamodel'
      expect { Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir) }
        .to raise_error 'The relationship "user" from "FidelityCard" is wrong - please fix it'
    end

    it 'check raising undefined type error' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'error_undefined_type.xcdatamodel'
      expect { Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir) }
        .to raise_error 'The attribute "name" from "Product" has no type - please fix it'
    end

    it 'check abstract entity' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'entity.xcdatamodel'
      xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.name).to eq 'Animal'
      expect(entity.parent).to eq ''
      expect(entity.abstract?).to be true
    end

    it 'check attribute' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'entity.xcdatamodel'
      xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.attributes.length).to eq 1
      attribute = entity.attributes.values.first
      expect(attribute.name).to eq 'animal'
      expect(attribute.optional?).to be true
      expect(attribute.default).to eq 'animalDefault'
    end

    it 'check relationship' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'relationship.xcdatamodel'
      xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 2
      entity1, entity2 = xcdatamodel.entities.values
      relationship = entity1.relationships.values.first
      relationship_inverse = entity2.relationships.values.first
      expect(relationship.inverse_name).to eq(relationship_inverse.name)
      expect(relationship_inverse.inverse_name).to eq(relationship.name)
    end

    it 'check relationship without destination' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'relationship_type.xcdatamodel'
      xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 1
      entity = xcdatamodel.entities.values.first
      expect(entity.relationships.length).to eq 1
      relationship = entity.relationships.values.first
      expect(relationship.name).to eq 'relationshipNoValue'
      expect(relationship.destination).to_not be_empty
      expect(relationship.type).to eq :to_many
    end

    it 'check global xcdatamodel' do
      xcdatamodel_dir = DATAMODEL_FIXTURES + 'global.xcdatamodel'
      xcdatamodel = Parser::XCDataModel::XCDataModel.new(xcdatamodel_dir)
      expect(xcdatamodel.entities.length).to eq 6
    end
  end
end
