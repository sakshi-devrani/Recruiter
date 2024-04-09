// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobfinder/Jobs/JobDetails.dart';
import 'package:jobfinder/user_admin/bottom_navigator.dart';

// Widget for the Job Search Page
class JobSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'search'.tr, // Translate 'search' text
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 85, 143, 151),
        ),
        body: JobList(), // Display the JobList widget
        bottomNavigationBar: Bottom_navigator_User(), // Display the bottom navigation bar
      ),
    );
  }
}

// Stateful widget for displaying the list of jobs
class JobList extends StatefulWidget {
  @override
  _JobListState createState() => _JobListState();
}

// State class for the JobList widget
class _JobListState extends State<JobList> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> jobDocs = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _getRecentSearches(); // Get recent searches from SharedPreferences when widget initializes
  }

  // Function to get recent searches from SharedPreferences
  Future<void> _getRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  // Function to save recent search to SharedPreferences
  Future<void> _saveRecentSearch(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
      await prefs.setStringList('recent_searches', recentSearches);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search TextField
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
            ),
            decoration: InputDecoration(
              hintText: 'Search Jobs'.tr, // Translate 'Search Jobs' text
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              _searchJobs(value); // Call search function when text changes
            },
          ),
        ),
        // Display recent searches if available
        recentSearches.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Searched:', // Display section header
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Display recent searches as chips
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: recentSearches
                          .map(
                            (search) => Chip(
                              label: Text(search),
                              onDeleted: () {
                                _removeRecentSearch(search); // Remove recent search when deleted
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        // Display job list or animation if available
        Expanded(
          child: jobDocs.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/animation_lmm6bvuc.json', // Placeholder animation
                    width: 350,
                    repeat: true,
                    reverse: false,
                    animate: true,
                  ),
                )
              : ListView.builder(
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    // Extract job details from document snapshot
                    var job = jobDocs[index].data() as Map<String, dynamic>;
                    var jobId = jobDocs[index].id;
                    var email = job['email'] as String? ?? 'no';
                    var jobTitle =
                        job['jobTitle'] as String? ?? 'Job Title Not Provided';
                    var companyName = job['companyName'] as String? ??
                        'Company Name Not Provided';
                    var salary =
                        job['salary'] as String? ?? 'Salary Not Provided';
                    var postedDate = job['postedDate'] as String? ?? 'no date';
                    var skills = job['skills'] as List<dynamic>?;
                    var skillsText = skills != null
                        ? skills.join(', ')
                        : 'Skills Not Provided';
                    // Return ListTile for each job
                    return Card(
                      color: Color.fromARGB(255, 234, 235, 235),
                      elevation: 1,
                      margin: EdgeInsets.all(6),
                      child: ListTile(
                        leading: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        title: Text(
                          jobTitle,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company: $companyName',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to job details page when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailPage(
                                  jobId: jobId,
                                  jobemail: email,
                                  jobtitle: jobTitle),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Function to remove recent search
  void _removeRecentSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches.remove(search);
      prefs.setStringList('recent_searches', recentSearches);
    });
  }

  // Function to perform job search
  void _searchJobs(String query) async {
    if (query.trim().isEmpty) {
      return; // Ignore empty queries
    }

    final CollectionReference jobsCollection =
        FirebaseFirestore.instance.collection('jobsposted');

    // Perform query based on job title
    jobsCollection
        .where('jobTitle', isGreaterThanOrEqualTo: query.trim())
        .where('jobTitle', isLessThan: _getNextWord(query.trim()))
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        jobDocs = querySnapshot.docs;
        _addToRecentSearches(
            query.trim()); // Add trimmed query to recent searches
      });
    }).catchError((error) {
      print("Error getting documents: $error");
    });
  }

  // Function to get the next word in lexicographic order
  String _getNextWord(String word) {
    String nextWord = word.substring(0, word.length - 1) +
        String.fromCharCode(word.codeUnitAt(word.length - 1) + 1);
    return nextWord;
  }

  // Function to add recent search to SharedPreferences
  void _addToRecentSearches(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recent_searches') ?? [];

    // Trim and sanitize the query before adding to recent searches
    query = query.trim();
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query); // Insert at the beginning of the list
      if (recentSearches.length > 5) {
        recentSearches.removeLast(); // Limit the list to 5 items
      }
      await prefs.setStringList('recent_searches', recentSearches);
      _getRecentSearches(); // Update recent searches in the UI
    }
  }
}
