import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
  Classifier();

  classifyImage(var image) async {
    var inputImage = File(image.path);

    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    TensorImage tensorImage = TensorImage.fromFile(inputImage);
    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize(<int>[1, 127], TfLiteType.float32);

    final interpreter = await Interpreter.fromAsset('yourmodel.tflite');
    interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);

    List<String> labels = await FileUtil.loadLabels("assets/labels.txt");
    SequentialProcessor<TensorBuffer> probabilityProcessor =
        TensorProcessorBuilder().build();
    TensorLabel tensorLabel = TensorLabel.fromList(
        labels, probabilityProcessor.process(probabilityBuffer));

    Map labeledProb = tensorLabel.getMapWithFloatValue();
    double highestProb = 0;
    String emotion = "";

    labeledProb.forEach((emo, probability) {
      if (probability * 100 > highestProb) {
        highestProb = probability * 100;
        emotion = emo;
      }
    });
    var outputProb = highestProb.toStringAsFixed(1);
    return [emotion, outputProb];
  }
}
