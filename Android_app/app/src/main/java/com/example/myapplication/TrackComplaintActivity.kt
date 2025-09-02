package com.example.myapplication

import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class TrackComplaintActivity : AppCompatActivity() {

    private lateinit var complaintIdEditText: EditText
    private lateinit var mobileNumberEditText: EditText
    private lateinit var trackButton: Button
    private lateinit var complaintDetailsLayout: LinearLayout
    private lateinit var statusView: RecyclerView
    private lateinit var complaintIdText: TextView
    private lateinit var complaintSubjectText: TextView
    private lateinit var departmentText: TextView
    private lateinit var dateText: TextView
    private lateinit var statusText: TextView
    private lateinit var provideFeedbackButton: Button
    private lateinit var downloadDocButton: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_track_complaint)

        // Initialize views
        complaintIdEditText = findViewById(R.id.complaint_id_edit_text)
        mobileNumberEditText = findViewById(R.id.mobile_number_edit_text)
        trackButton = findViewById(R.id.track_button)
        complaintDetailsLayout = findViewById(R.id.complaint_details_layout)
        complaintIdText = findViewById(R.id.complaint_id_text)
        complaintSubjectText = findViewById(R.id.complaint_subject_text)
        departmentText = findViewById(R.id.department_text)
        dateText = findViewById(R.id.date_text)
        statusText = findViewById(R.id.status_text)
        provideFeedbackButton = findViewById(R.id.provide_feedback_button)
        downloadDocButton = findViewById(R.id.download_doc_button)
        statusView = findViewById(R.id.status_updates_recycler)

        // Initially hide complaint details
        complaintDetailsLayout.visibility = View.GONE

        // Setup click listeners
        trackButton.setOnClickListener {
            val complaintId = complaintIdEditText.text.toString()
            val mobileNumber = mobileNumberEditText.text.toString()

            if (validateInput(complaintId, mobileNumber)) {
                // Simulate tracking - in a real app, this would make an API call
                showComplaintDetails()
            }
        }

        provideFeedbackButton.setOnClickListener {
            showFeedbackDialog()
        }

        downloadDocButton.setOnClickListener {
            Toast.makeText(this, "Downloading response document...", Toast.LENGTH_SHORT).show()
        }
    }

    private fun validateInput(complaintId: String, mobileNumber: String): Boolean {
        var valid = true

        if (complaintId.isEmpty()) {
            complaintIdEditText.error = "Please enter your complaint ID"
            valid = false
        }

        if (mobileNumber.isEmpty() || mobileNumber.length != 10) {
            mobileNumberEditText.error = "Please enter a valid 10-digit mobile number"
            valid = false
        }

        return valid
    }

    private fun showComplaintDetails() {
        // In a real app, these would come from the API response
        complaintIdText.text = "JSCMP-2023-12345"
        complaintSubjectText.text = "Road repair in sector 15"
        departmentText.text = "Public Works Department"
        dateText.text = "05-Oct-2023"
        statusText.text = "In Progress"

        // Show the complaint details layout
        complaintDetailsLayout.visibility = View.VISIBLE

        // Setup status updates
        setupStatusUpdates()
    }

    private fun setupStatusUpdates() {
        // In a real app, this would use an adapter with real data
        // For this prototype, we just show a message
        Toast.makeText(this, "Status updates would be displayed in a list", Toast.LENGTH_SHORT).show()
    }

    private fun showFeedbackDialog() {
        val options = arrayOf("Very Satisfied", "Satisfied", "Neutral", "Dissatisfied", "Very Dissatisfied")
        
        AlertDialog.Builder(this)
            .setTitle("How satisfied are you with the response?")
            .setItems(options) { dialog, which ->
                Toast.makeText(
                    this,
                    "Thank you for your feedback: ${options[which]}",
                    Toast.LENGTH_LONG
                ).show()
                dialog.dismiss()
            }
            .setNegativeButton("Cancel") { dialog, _ -> dialog.dismiss() }
            .show()
    }
} 