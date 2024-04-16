// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_detail_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _VideoDetailApiService implements VideoDetailApiService {
  _VideoDetailApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://34.87.143.194:8080';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<VideoDetailResponse>> videoDetail(
      VideoDetailRequestBody body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    print(_data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<VideoDetailResponse>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/video-info',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    print('//////////result///////////');
    print(_result.data?['video_detail']);
    final value = VideoDetailResponse.fromJson(_result.data?['video_detail']);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
