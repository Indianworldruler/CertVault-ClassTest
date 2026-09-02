Name: Parth Sahani
Roll Number: 150096724135
Cohort: Elon Musk

1. Home List Screen Widget Tree
Scaffold – Main structure of the screen.
AppBar – Displays CertVault, Search and Filter buttons.
Body → ListView.builder – Displays all certification cards.
Card – Shows certification title, issuer, dates and status.
FloatingActionButton – Opens the Add Certification screen.
BottomNavigationBar – Provides Home and About navigation.
2. Add Certification Screen Widget Tree
Scaffold – Main screen structure.
AppBar – Shows the Add Certification title and navigation.
SingleChildScrollView – Allows the form to scroll.
Form – Validates the certification information.
TextFormField / DropdownButtonFormField – Takes certification title, issuer, dates, credential details and renewal status.
ElevatedButton – Saves the certification.
3. Details Screen Widget Tree
Scaffold – Main screen structure.
AppBar – Shows Certification Details with Back and Edit actions.
SingleChildScrollView – Allows all details to fit on smaller screens.
Column – Organises the certification information vertically.
Icon/Logo + Title + Subtitle – Displays the certification identity.
ListTile / Detail sections – Shows issue date, expiry date, credential ID/URL, renewal status and notes.
OutlinedButton – Opens the credential/search option.


App Functions
View Certifications: Displays all saved certifications with their title, issuer, issue date, expiry date and renewal status.
Add Certification: Allows users to add a new certification with complete details.
Search Certifications: Searches certifications by their name.
View Details: Shows complete information about a selected certification.
Credential Access: Allows users to open/search the credential information.
Renewal Tracking: Displays the current renewal status of each certification.
About: Shows the user's project/student information.

How to Use
Open the app on the Home screen to view certifications.
Tap the + button to add a new certification.
Enter the certification details and tap Save Certification.
Tap any certification card to view its details.
Use the Search icon to find a certification by name.
Use the Open Credential option to access the credential.
Use the About section to view project/user information.
