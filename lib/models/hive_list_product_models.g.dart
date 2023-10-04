// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_list_product_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveListProductModelAdapter extends TypeAdapter<HiveListProductModel> {
  @override
  final int typeId = 2;

  @override
  HiveListProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveListProductModel(
      listOfProduct: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, HiveListProductModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.listOfProduct);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveListProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
