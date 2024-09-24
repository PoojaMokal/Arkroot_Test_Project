import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:chat_gpt_demo/core/constants/strings/strings_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DynamoService {
  final service = DynamoDB(
    region: 'ap-south-1',
    credentials: AwsClientCredentials(
      accessKey: dotenv.env['AMPLIFY_ACCESS_KEY']!,
      secretKey: dotenv.env['AMPLIFY_SECRET_KEY']!,
    ),
  );

  Future createTable() async {
    final CreateTableOutput output = await service.createTable(
      attributeDefinitions: [
        AttributeDefinition(
            attributeName: Strings.email, attributeType: ScalarAttributeType.s),
      ],
      keySchema: [
        KeySchemaElement(attributeName: Strings.email, keyType: KeyType.hash),
      ],
      provisionedThroughput:
          ProvisionedThroughput(readCapacityUnits: 10, writeCapacityUnits: 10),
      tableName: Strings.usersTableName,
    );

    debugPrint("tableDescription: ${output.tableDescription?.itemCount}");
  }

  Future<List<Map<String, AttributeValue>>?> getAll() async {
    ScanOutput reslut = await service.scan(tableName: Strings.usersTableName);

    return reslut.items;
  }

  Future<PutItemOutput> insertNewItem(
      Map<String, AttributeValue> dbData) async {
    PutItemOutput output =
        await service.putItem(item: dbData, tableName: Strings.usersTableName);

    return output;
  }

  Future getUserItem(String email) async {
    final attribute = {
      Strings.email: AttributeValue(s: email),
    };
    final GetItemOutput output = await service.getItem(
      key: attribute,
      tableName: Strings.usersTableName,
    );
  }
}
