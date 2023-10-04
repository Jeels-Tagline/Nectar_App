// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductModelAdapter extends TypeAdapter<HiveProductModel> {
  @override
  final int typeId = 1;

  @override
  HiveProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      subTitle: fields[2] as String,
      price: fields[3] as double,
      detail: fields[4] as String,
      nutrition: fields[5] as String,
      review: fields[6] as int,
      type: fields[7] as String,
      image1: fields[8] as String,
      image2: fields[9] as String,
      image3: fields[10] as String,
      quantity: fields[11] as int?,
      favourite: fields[12] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveProductModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.detail)
      ..writeByte(5)
      ..write(obj.nutrition)
      ..writeByte(6)
      ..write(obj.review)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.image1)
      ..writeByte(9)
      ..write(obj.image2)
      ..writeByte(10)
      ..write(obj.image3)
      ..writeByte(11)
      ..write(obj.quantity)
      ..writeByte(12)
      ..write(obj.favourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
