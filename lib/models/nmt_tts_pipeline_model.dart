class NmtTtsModel {
  NmtTtsModel({
    required this.pipelineResponse,
  });

  final List<PipelineResponse> pipelineResponse;

  NmtTtsModel copyWith({
    List<PipelineResponse>? pipelineResponse,
  }) {
    return NmtTtsModel(
      pipelineResponse: pipelineResponse ?? this.pipelineResponse,
    );
  }

  factory NmtTtsModel.fromJson(Map<String, dynamic> json) {
    return NmtTtsModel(
      pipelineResponse: json["pipelineResponse"] == null
          ? []
          : List<PipelineResponse>.from(json["pipelineResponse"]!
              .map((x) => PipelineResponse.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "pipelineResponse": pipelineResponse.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$pipelineResponse, ";
  }
}

class PipelineResponse {
  PipelineResponse({
    required this.taskType,
    required this.config,
    required this.output,
    required this.audio,
  });

  final String? taskType;
  final Config? config;
  final List<Output> output;
  final List<Audio> audio;

  PipelineResponse copyWith({
    String? taskType,
    Config? config,
    List<Output>? output,
    List<Audio>? audio,
  }) {
    return PipelineResponse(
      taskType: taskType ?? this.taskType,
      config: config ?? this.config,
      output: output ?? this.output,
      audio: audio ?? this.audio,
    );
  }

  factory PipelineResponse.fromJson(Map<String, dynamic> json) {
    return PipelineResponse(
      taskType: json["taskType"],
      config: json["config"] == null ? null : Config.fromJson(json["config"]),
      output: json["output"] == null
          ? []
          : List<Output>.from(json["output"]!.map((x) => Output.fromJson(x))),
      audio: json["audio"] == null
          ? []
          : List<Audio>.from(json["audio"]!.map((x) => Audio.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "taskType": taskType,
        "config": config?.toJson(),
        "output": output.map((x) => x.toJson()).toList(),
        "audio": audio.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$taskType, $config, $output, $audio, ";
  }
}

class Audio {
  Audio({
    required this.audioContent,
    required this.audioUri,
  });

  final String? audioContent;
  final dynamic audioUri;

  Audio copyWith({
    String? audioContent,
    dynamic audioUri,
  }) {
    return Audio(
      audioContent: audioContent ?? this.audioContent,
      audioUri: audioUri ?? this.audioUri,
    );
  }

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      audioContent: json["audioContent"],
      audioUri: json["audioUri"],
    );
  }

  Map<String, dynamic> toJson() => {
        "audioContent": audioContent,
        "audioUri": audioUri,
      };

  @override
  String toString() {
    return "$audioContent, $audioUri, ";
  }
}

class Config {
  Config({
    required this.audioFormat,
    required this.language,
    required this.encoding,
    required this.samplingRate,
  });

  final String? audioFormat;
  final Language? language;
  final String? encoding;
  final int? samplingRate;

  Config copyWith({
    String? audioFormat,
    Language? language,
    String? encoding,
    int? samplingRate,
  }) {
    return Config(
      audioFormat: audioFormat ?? this.audioFormat,
      language: language ?? this.language,
      encoding: encoding ?? this.encoding,
      samplingRate: samplingRate ?? this.samplingRate,
    );
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      audioFormat: json["audioFormat"],
      language:
          json["language"] == null ? null : Language.fromJson(json["language"]),
      encoding: json["encoding"],
      samplingRate: json["samplingRate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "audioFormat": audioFormat,
        "language": language?.toJson(),
        "encoding": encoding,
        "samplingRate": samplingRate,
      };

  @override
  String toString() {
    return "$audioFormat, $language, $encoding, $samplingRate, ";
  }
}

class Language {
  Language({
    required this.sourceLanguage,
    required this.sourceScriptCode,
  });

  final String? sourceLanguage;
  final String? sourceScriptCode;

  Language copyWith({
    String? sourceLanguage,
    String? sourceScriptCode,
  }) {
    return Language(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      sourceScriptCode: sourceScriptCode ?? this.sourceScriptCode,
    );
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      sourceLanguage: json["sourceLanguage"],
      sourceScriptCode: json["sourceScriptCode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sourceLanguage": sourceLanguage,
        "sourceScriptCode": sourceScriptCode,
      };

  @override
  String toString() {
    return "$sourceLanguage, $sourceScriptCode, ";
  }
}

class Output {
  Output({
    required this.source,
    required this.target,
  });

  final String? source;
  final String? target;

  Output copyWith({
    String? source,
    String? target,
  }) {
    return Output(
      source: source ?? this.source,
      target: target ?? this.target,
    );
  }

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
      source: json["source"],
      target: json["target"],
    );
  }

  Map<String, dynamic> toJson() => {
        "source": source,
        "target": target,
      };

  @override
  String toString() {
    return "$source, $target, ";
  }
}
