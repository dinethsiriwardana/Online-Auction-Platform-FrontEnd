import 'dart:convert';
import 'dart:html' as html;
import 'dart:html' show window;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

//http
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:online_auction_platform/data/api/api.dart';
import 'package:online_auction_platform/data/controller/item_controller.dart';
import 'package:online_auction_platform/utl/dat_time_formatter.dart'; // Import the intl package for date formatting

class AddBidScreen extends StatefulWidget {
  const AddBidScreen({Key? key});

  @override
  State<AddBidScreen> createState() => _AddBidScreenState();
}

class _AddBidScreenState extends State<AddBidScreen> {
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiredAtController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startPriceController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();

  String get _createdAt => _createdAtController.text;
  String get _description => _descriptionController.text;
  String get _expiredAt => _expiredAtController.text;
  String get _name => _nameController.text;
  String get _startPrice => _startPriceController.text;

  final ImagePicker _picker = ImagePicker();
  final ItemController itemController = Get.put(ItemController());

  String? _pickedImagePath;

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _pickedImagePath = reader.result as String?;
          });
        });
      }
    });
  }

  void _submit() async {
    try {
      final itemresponse = await http.post(
        Uri.parse(Api.items),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "name": _name,
          "description": _description,
          "start_price": double.parse(_startPrice),
          "add_by": window.localStorage["token"],
          "expiredAt": _dateTimeController.text,
          "createdAt": DayTimeFormatter().formatLocalTime(DateTime.now())
        }),
      );
      if (itemresponse.statusCode == 200) {
        print('Item Added');

        if (_pickedImagePath != null) {
          //get itemresponse
          Map data = jsonDecode(itemresponse.body);

          final bytes = base64.decode(_pickedImagePath!.split(',').last);
          final blob = html.Blob([bytes]);
          final file = html.File([blob], 'image.png');
          final formData = html.FormData();
          formData.appendBlob('file', file);
          formData.append('itemId', data['itemId']); // Change item ID as needed

          final xhr = html.HttpRequest();
          xhr.open(
              'POST', Api.file); // Use the same API URL as for the item data
          xhr.send(formData);

          xhr.onLoad.listen((event) {
            if (xhr.status == 200) {
              print('Image Uploaded');
            } else {
              print('Error uploading image: ${xhr.statusText}');
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Bid Form',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.0),
          _buildTextField(_nameController, 'Name', 'Enter name'),
          SizedBox(height: 10.0),
          _buildTextField(
              _descriptionController, 'Description', 'Enter description'),
          SizedBox(height: 10.0),
          _buildTextField(
              _startPriceController, 'Start Price', 'Enter start price'),
          SizedBox(height: 20.0),
          _buildDateTimePicker(_dateTimeController, 'Select Date and Time',
              'Pick a date and time'),
          SizedBox(height: 10.0),
          _pickedImagePath != null
              ? SizedBox(height: 100, child: Image.network(_pickedImagePath!))
              : Text('No image picked'),
          SizedBox(height: 20.0),
          SizedBox(
            width: 320.0,
            height: 55.0,
            child: ElevatedButton(
              onPressed: () {
                _pickImageFromGallery(context);
              },
              child: Text(
                  _pickedImagePath == null ? 'Select Image' : 'Change Image'),
            ),
          ),
          SizedBox(height: 20.0),
          _pickedImagePath == null
              ? SizedBox()
              : SizedBox(
                  width: 320.0,
                  height: 55.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();

                      Get.back();
                    },
                    child: Text('Submit'),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 216, 122, 0), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          hintText: hint,
          labelText: label,
          hintStyle: TextStyle(fontSize: 15),
          labelStyle: TextStyle(fontSize: 15),
        ),
        onChanged: (value) => _updateState(),
      ),
    );
  }

  Widget _buildDateTimePicker(
      TextEditingController controller, String label, String hint) {
    return SizedBox(
      width: 320.0,
      height: 55.0,
      child: InkWell(
        onTap: () async {
          final DateTime? pickedDateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDateTime != null) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              setState(() {
                controller.text =
                    DateFormat('yyyy-MM-ddTHH:mm:ss.S').format(DateTime(
                  pickedDateTime.year,
                  pickedDateTime.month,
                  pickedDateTime.day,
                  pickedTime.hour,
                  pickedTime.minute,
                ));
              });
            }
          }
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 216, 122, 0), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: hint,
              hintStyle: TextStyle(fontSize: 15),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
