package com.mizuki.Ohashi.Pilll

import android.app.PendingIntent
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

public class PilllFirebaseMessagingService: FirebaseMessagingService() {
    companion object {
        val regularlyMessageID = 1
    }
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d("android message: ", "onMessageReceived")
        send(remoteMessage.data)
    }

    fun send( data: Map<String, String>) {
        Log.d("android message: ", "send")

        val mainActivityIntent = Intent(this, MainActivity::class.java).also {
            it.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        val openAppPendingIntent = PendingIntent.getActivity( this,0, mainActivityIntent, 0)
        val title = data["title"]
        val body = data["body"]
        val builder = NotificationCompat.Builder(this, "PILL_REMINDER")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setLargeIcon(BitmapFactory.decodeResource(resources,
                R.mipmap.ic_launcher))
            .setContentTitle(title + "y")
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(openAppPendingIntent)
            .setAutoCancel(true)

        if (data["action"] == "PILL_REMINDER") {
            val intent = Intent(this, BroadCastActionReceiver::class.java).apply {
                action = "PILL_REMINDER"
            }
            val pendingIntent: PendingIntent =
                    PendingIntent.getBroadcast(this, 0, intent, 0)

            builder.addAction(0, "飲んだ", pendingIntent)
        }

        with(NotificationManagerCompat.from(this)) {
            // notificationId is a unique int for each notification that you must define
            notify(regularlyMessageID, builder.build())
        }
    }
}
