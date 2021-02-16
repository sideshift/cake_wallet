package com.cakewallet.cake_wallet;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import zendesk.chat.Chat;
import zendesk.chat.ChatConfiguration;
import zendesk.chat.ChatEngine;
import zendesk.chat.ChatProvider;
import zendesk.chat.PreChatFormFieldStatus;
import zendesk.chat.ProfileProvider;
import zendesk.chat.VisitorInfo;
import zendesk.messaging.MessagingActivity;


public class MainActivity extends FlutterFragmentActivity {
    final String LIVE_CHAT_CHANNEL = "com.cakewallet.cake_wallet/live-chat";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel liveChatChannel =
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                        LIVE_CHAT_CHANNEL);

        liveChatChannel.setMethodCallHandler(this::handle);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Chat.INSTANCE.init(getApplicationContext(),
                "Account key", "com.cakewallet.cake_wallet");
    }

    private void handle(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            if (call.method.equals("startLiveChat")) {
                startLiveChat();
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            result.error("UNCAUGHT_ERROR", e.getMessage(), null);
        }
    }

    private  void startLiveChat() {
        ProfileProvider profileProvider = Chat.INSTANCE.providers().profileProvider();
        VisitorInfo visitorInfo = VisitorInfo.builder().build();
        profileProvider.setVisitorInfo(visitorInfo, null);

        ChatProvider chatProvider = Chat.INSTANCE.providers().chatProvider();
        chatProvider.setDepartment("Cake Wallet", null);

        ChatConfiguration chatConfiguration = ChatConfiguration.builder()
                .withPreChatFormEnabled(true)
                .withNameFieldStatus(PreChatFormFieldStatus.REQUIRED)
                .withEmailFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                .withPhoneFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                .build();

        MessagingActivity.builder()
                .withEngines(ChatEngine.engine())
                .withBotLabelString("Cake Wallet Bot")
                .show(this, chatConfiguration);
    }
}