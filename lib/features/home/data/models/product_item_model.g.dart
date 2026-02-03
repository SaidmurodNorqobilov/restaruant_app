// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductItemModelAdapter extends TypeAdapter<ProductItemModel> {
  @override
  final int typeId = 0;

  @override
  ProductItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductItemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      price: fields[3] as double,
      image: fields[4] as String,
      vat: fields[5] as int,
      measureUnit: fields[6] as String,
      measure: fields[7] as int,
      sortOrder: fields[8] as int,
      isActive: fields[9] as bool,
      categoryId: fields[10] as String,
      modifierGroups: (fields[11] as List).cast<ProductModifierGroupModel>(),
      quantity: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductItemModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.vat)
      ..writeByte(6)
      ..write(obj.measureUnit)
      ..writeByte(7)
      ..write(obj.measure)
      ..writeByte(8)
      ..write(obj.sortOrder)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.categoryId)
      ..writeByte(11)
      ..write(obj.modifierGroups)
      ..writeByte(12)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductModifierGroupModelAdapter
    extends TypeAdapter<ProductModifierGroupModel> {
  @override
  final int typeId = 1;

  @override
  ProductModifierGroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModifierGroupModel(
      id: fields[0] as String,
      name: fields[1] as String,
      sortOrder: fields[2] as int,
      minSelectedAmount: fields[3] as int,
      maxSelectedAmount: fields[4] as int,
      modifiers: (fields[5] as List).cast<ModifiersModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModifierGroupModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sortOrder)
      ..writeByte(3)
      ..write(obj.minSelectedAmount)
      ..writeByte(4)
      ..write(obj.maxSelectedAmount)
      ..writeByte(5)
      ..write(obj.modifiers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModifierGroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModifiersModelAdapter extends TypeAdapter<ModifiersModel> {
  @override
  final int typeId = 2;

  @override
  ModifiersModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModifiersModel(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      maxQuantity: fields[3] as int,
      sortOrder: fields[4] as int,
      image: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModifiersModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.maxQuantity)
      ..writeByte(4)
      ..write(obj.sortOrder)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifiersModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
