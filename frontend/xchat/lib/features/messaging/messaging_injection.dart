import 'package:xchat/core/gateways/local_database.dart';
import 'package:xchat/core/gateways/backend_gateway.dart';
import 'package:xchat/core/gateways/realtime_gateway.dart';
import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/core/services/clock.dart';
import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/core/services/id_generator.dart';
import 'package:xchat/features/messaging/data/datasources/draft_local_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/impl/draft_local_datasource_impl.dart';
import 'package:xchat/features/messaging/data/datasources/impl/message_local_datasource_impl.dart';
import 'package:xchat/features/messaging/data/datasources/impl/message_realtime_datasource_impl.dart';
import 'package:xchat/features/messaging/data/datasources/impl/message_remote_datasource_impl.dart';
import 'package:xchat/features/messaging/data/datasources/message_local_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_realtime_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:xchat/features/messaging/data/mappers/draft_mapper.dart';
import 'package:xchat/features/messaging/data/mappers/message_mapper.dart';
import 'package:xchat/features/messaging/data/models/draft_model.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';
import 'package:xchat/features/messaging/data/repositories/impl/draft_repository_impl.dart';
import 'package:xchat/features/messaging/data/repositories/impl/message_repository_impl.dart';
import 'package:xchat/features/messaging/data/repositories/impl/outbox_repository_impl.dart';
import 'package:xchat/features/messaging/domain/entities/draft.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/repositories/draft_repository.dart';
import 'package:xchat/features/messaging/domain/repositories/message_repository.dart';
import 'package:xchat/features/messaging/domain/repositories/outbox_repository.dart';
import 'package:xchat/features/messaging/domain/services/outbox_sync_service.dart';
import 'package:xchat/features/messaging/domain/usecases/draft_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/message_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/outbox_usecases.dart';
import 'package:xchat/features/messaging/domain/usecases/send_message.dart';
import 'package:xchat/features/messaging/presentation/bloc/composer/message_composer_bloc.dart';
import 'package:xchat/features/messaging/presentation/bloc/message_list/message_list_bloc.dart';
import 'package:get_it/get_it.dart';

/// Composition root of the messaging feature: the ONLY place (together with
/// core/di) allowed to reference `*Impl` classes.
void registerMessagingDependencies(GetIt sl) {
  sl
    // mappers
    ..registerLazySingleton<EntityMapper<MessageModel, Message>>(() => const MessageMapper())
    ..registerLazySingleton<EntityMapper<DraftModel, Draft>>(() => const DraftMapper())
    // data sources
    ..registerLazySingleton<MessageRemoteDataSource>(
      () => MessageRemoteDataSourceImpl(sl<BackendGateway>(), sl<Clock>()),
    )
    ..registerLazySingleton<MessageLocalDataSource>(() => MessageLocalDataSourceImpl(sl<LocalDatabase>()))
    ..registerLazySingleton<MessageRealtimeDataSource>(
      () => MessageRealtimeDataSourceImpl(sl<RealtimeGateway>()),
    )
    ..registerLazySingleton<DraftLocalDataSource>(() => DraftLocalDataSourceImpl(sl<LocalDatabase>()))
    // repositories
    ..registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(
        remote: sl<MessageRemoteDataSource>(),
        local: sl<MessageLocalDataSource>(),
        realtime: sl<MessageRealtimeDataSource>(),
        mapper: sl<EntityMapper<MessageModel, Message>>(),
      ),
    )
    ..registerLazySingleton<OutboxRepository>(
      () => OutboxRepositoryImpl(
        remote: sl<MessageRemoteDataSource>(),
        local: sl<MessageLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<DraftRepository>(
      () => DraftRepositoryImpl(
        local: sl<DraftLocalDataSource>(),
        mapper: sl<EntityMapper<DraftModel, Draft>>(),
      ),
    )
    // use cases
    ..registerLazySingleton(
      () => SendMessage(
        messages: sl<MessageRepository>(),
        outbox: sl<OutboxRepository>(),
        ids: sl<IdGenerator>(),
        clock: sl<Clock>(),
      ),
    )
    ..registerLazySingleton(() => WatchMessages(sl<MessageRepository>()))
    ..registerLazySingleton(() => RefreshLatestMessages(sl<MessageRepository>()))
    ..registerLazySingleton(() => LoadOlderMessages(sl<MessageRepository>()))
    ..registerLazySingleton(() => EditMessage(sl<MessageRepository>()))
    ..registerLazySingleton(() => DeleteMessage(sl<MessageRepository>()))
    ..registerLazySingleton(() => ReactToMessage(sl<MessageRepository>()))
    ..registerLazySingleton(() => MarkMessagesRead(sl<MessageRepository>()))
    ..registerLazySingleton(() => SubscribeToConversation(sl<MessageRepository>()))
    ..registerLazySingleton(() => UnsubscribeFromConversation(sl<MessageRepository>()))
    ..registerLazySingleton(() => FlushOutbox(sl<OutboxRepository>()))
    ..registerLazySingleton(() => RetryMessage(sl<OutboxRepository>()))
    ..registerLazySingleton(() => RecoverInterruptedSends(sl<OutboxRepository>()))
    ..registerLazySingleton(() => GetDraft(sl<DraftRepository>()))
    ..registerLazySingleton(() => SaveDraft(sl<DraftRepository>(), sl<Clock>()))
    ..registerLazySingleton(() => ClearDraft(sl<DraftRepository>()))
    ..registerLazySingleton(
      () => OutboxSyncService(
        connectivity: sl<ConnectivityService>(),
        flushOutbox: sl(),
        recoverInterruptedSends: sl(),
      ),
    )
    // blocs: conversation-scoped. Create at the chat route:
    //   sl<MessageListBloc>(param1: conversationId, param2: currentUserId)
    ..registerFactoryParam<MessageListBloc, String, String>(
      (conversationId, currentUserId) => MessageListBloc(
        conversationId: conversationId,
        currentUserId: currentUserId,
        watchMessages: sl(),
        refreshLatest: sl(),
        loadOlder: sl(),
        subscribe: sl(),
        unsubscribe: sl(),
        deleteMessage: sl(),
        reactToMessage: sl(),
        retryMessage: sl(),
      ),
    )
    ..registerFactoryParam<MessageComposerBloc, String, String>(
      (conversationId, senderId) => MessageComposerBloc(
        conversationId: conversationId,
        senderId: senderId,
        sendMessage: sl(),
        editMessage: sl(),
        getDraft: sl(),
        saveDraft: sl(),
        clearDraft: sl(),
      ),
    );
}
