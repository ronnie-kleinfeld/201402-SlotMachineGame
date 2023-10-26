/*
 * [ADMMessenger]
 *
 * (c) 2012, Amazon.com, Inc. or its affiliates. All Rights Reserved.
 */

package com.amazon.sample.admmessenger;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.content.Context;
import android.app.Notification;
import android.app.Notification.Builder;
import android.app.NotificationManager;
import android.app.PendingIntent;

import com.amazon.device.messaging.ADMConstants;
import com.amazon.device.messaging.ADMMessageHandlerBase;
import com.amazon.device.messaging.ADMMessageReceiver;

/**
 * The SampleADMMessageHandler class receives messages sent by ADM via the MessageAlertReceiver receiver.
 *
 * @version Revision: 1, Date: 11/11/2012
 */
public class SampleADMMessageHandler extends ADMMessageHandlerBase 
{
    /** Tag for logs. */
    private final static String TAG = "ADMSampleMessenger";

    /**
     * The MessageAlertReceiver class listens for messages from ADM and forwards them to the 
     * SampleADMMessageHandler class.
     */
    public static class MessageAlertReceiver extends ADMMessageReceiver
    {
        /** {@inheritDoc} */
        public MessageAlertReceiver()
        {
            super(SampleADMMessageHandler.class);
        }
    }

    /**
     * Class constructor.
     */
    public SampleADMMessageHandler()
    {
        super(SampleADMMessageHandler.class.getName());
    }
	
    /**
     * Class constructor, including the className argument.
     * 
     * @param className The name of the class.
     */
    public SampleADMMessageHandler(final String className) 
    {
        super(className);
    }

    /** {@inheritDoc} */
    @Override
    protected void onMessage(final Intent intent) 
    {
        Log.i(TAG, "SampleADMMessageHandler:onMessage");

        /* String to access message field from data JSON. */
        final String msgKey = getString(R.string.json_data_msg_key);

        /* String to access timeStamp field from data JSON. */
        final String timeKey = getString(R.string.json_data_time_key);
        
        /* Intent action that will be triggered in onMessage() callback. */
        final String intentAction = getString(R.string.intent_msg_action);

        /* Extras that were included in the intent. */
        final Bundle extras = intent.getExtras();
        
        verifyMD5Checksum(extras);
        
        /* Extract message from the extras in the intent. */
        final String msg = extras.getString(msgKey);
        final String time = extras.getString(timeKey);

        if (msg == null || time == null)
        {
            Log.w(TAG, "SampleADMMessageHandler:onMessage Unable to extract message data." +
                    "Make sure that msgKey and timeKey values match data elements of your JSON message");
        }

        /* Create a notification with message data. */
        /* This is required to test cases where the app or devicemay be off. */
        postNotification(msgKey, timeKey, intentAction, msg, time);

        /* Intent category that will be triggered in onMessage() callback. */
        final String msgCategory = getString(R.string.intent_msg_category);
        
        /* Broadcast an intent to update the app UI with the message. */
        /* The broadcast receiver will only catch this intent if the app is within the onResume state of its lifecycle. */
        /* User will see a notification otherwise. */
        final Intent broadcastIntent = new Intent();
        broadcastIntent.setAction(intentAction);
        broadcastIntent.addCategory(msgCategory);
        broadcastIntent.putExtra(msgKey, msg);
        broadcastIntent.putExtra(timeKey, time);
        this.sendBroadcast(broadcastIntent);

    }

    /**
     * This method posts a notification to notification manager.
     * 
     * @param msgKey String to access message field from data JSON.
     * @param timeKey String to access timeStamp field from data JSON.
     * @param intentAction Intent action that will be triggered in onMessage() callback.
     * @param msg Message that is included in the ADM message.
     * @param time Timestamp of the ADM message.
     */
    private void postNotification(final String msgKey, final String timeKey,
            final String intentAction, final String msg, final String time) 
    {
        final Context context = getApplicationContext();
        final NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        final Builder notificationBuilder = new Notification.Builder(context);

        /* Clicking the notification should bring up the MainActivity. */
        /* Intent FLAGS prevent opening multiple instances of MainActivity. */
        final Intent notificationIntent = new Intent(context, MainActivity.class);
        notificationIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        notificationIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        notificationIntent.putExtra(msgKey, msg);
        notificationIntent.putExtra(timeKey, time);
        /* Android reuses intents that have the same action. Adding a time stamp to the action ensures that */
        /* the notification intent received in onResume() isn't one that was recycled and that may hold old extras. */
        notificationIntent.setAction(intentAction + time);

        final PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, Notification.DEFAULT_LIGHTS | Notification.FLAG_AUTO_CANCEL);
        
        final Notification notification = notificationBuilder.setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle("Message Received!")
                .setContentText(msg)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .getNotification();

        /* Posting notification on notification bar. */
        final int notificationId = context.getResources().getInteger(R.integer.sample_app_notification_id);
        mNotificationManager.notify(notificationId, notification);
    }

    /**
     * This method verifies the MD5 checksum of the ADM message.
     * 
     * @param extras Extra that was included with the intent.
     */
    private void verifyMD5Checksum(final Bundle extras) 
    {
        /* String to access consolidation key field from data JSON. */
        final String consolidationKey = getString(R.string.json_data_consolidation_key);
        
        final Set<String> extrasKeySet = extras.keySet();
        final Map<String, String> extrasHashMap = new HashMap<String, String>();
        for (String key : extrasKeySet)
        {
            if (!key.equals(ADMConstants.EXTRA_MD5) && !key.equals(consolidationKey))
            {
                extrasHashMap.put(key, extras.getString(key));
            }            
        }
        final ADMSampleMD5ChecksumCalculator checksumCalculator = new ADMSampleMD5ChecksumCalculator();
        final String md5 = checksumCalculator.calculateChecksum(extrasHashMap);
        Log.i(TAG, "SampleADMMessageHandler:onMessage App md5: " + md5);
        
        /* Extract md5 from the extras in the intent. */
        final String admMd5 = extras.getString(ADMConstants.EXTRA_MD5);
        Log.i(TAG, "SampleADMMessageHandler:onMessage ADM md5: " + admMd5);
        
        /* Data integrity check. */
        if(!admMd5.trim().equals(md5.trim()))
        {
            Log.w(TAG, "SampleADMMessageHandler:onMessage MD5 checksum verification failure. " +
            		"Message received with errors");
        }
    }

    /** {@inheritDoc} */
    @Override
    protected void onRegistrationError(final String string)
    {
        Log.e(TAG, "SampleADMMessageHandler:onRegistrationError " + string);
    }

    /** {@inheritDoc} */
    @Override
    protected void onRegistered(final String registrationId) 
    {
        Log.i(TAG, "SampleADMMessageHandler:onRegistered");
        Log.i(TAG, registrationId);

        /* Register the app instance's registration ID with your server. */
        MyServerMsgHandler srv = new MyServerMsgHandler();
        srv.registerAppInstance(getApplicationContext(), registrationId);
    }

    /** {@inheritDoc} */
    @Override
    protected void onUnregistered(final String registrationId) 
    {
        Log.i(TAG, "SampleADMMessageHandler:onUnregistered");

        /* Unregister the app instance's registration ID with your server. */
        MyServerMsgHandler srv = new MyServerMsgHandler();
        srv.unregisterAppInstance(getApplicationContext(), registrationId);
    }
}
