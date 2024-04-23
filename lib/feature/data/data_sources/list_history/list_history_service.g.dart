// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_history_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ListHistoryApiService implements ListHistoryApiService {
  _ListHistoryApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://34.29.126.183:8080';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<ListHistoryResponse>> listHistory(
      ListHistoryRequestBody body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<HttpResponse<ListHistoryResponse>>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        ).compose(
          _dio.options,
          '/list-queue-history',
          queryParameters: queryParameters,
          data: _data,
        ).copyWith(
          baseUrl: _combineBaseUrls(
            _dio.options.baseUrl,
            baseUrl,
          ),
        ),
      ),
    );
    print("leo list history");
    try {
      final data = _result.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final value = ListHistoryResponse.fromJson(data['data']);
        print(value);
        final httpResponse = HttpResponse(value, _result);
        return httpResponse;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      // Handle parsing errors or other exceptions
      throw Exception('Failed to parse response: $e');
    }
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
