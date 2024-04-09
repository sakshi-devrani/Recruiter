import 'package:flutter/material.dart';

class Privacy_Policy extends StatefulWidget {
  const Privacy_Policy({super.key});

  @override
  State<Privacy_Policy> createState() => _Privacy_PolicyState();
}

class _Privacy_PolicyState extends State<Privacy_Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leadingWidth: 200,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          "Recruiter",
          style: TextStyle(
              color: Color.fromARGB(255, 85, 143, 151),
              fontSize: 40,
              fontFamily: "GreatVibes-Regular"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(39, 158, 158, 158),
              width: 1000,
              height: 70,
              child: Center(
                  child: Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 25),
              )),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Effective March 6, 2024",
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 143, 151),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Our Privacy Policy has been updated.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Privacy Matters",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Recruiter’s mission is to connect the world’s professionals to allow them to be more productive and successful. Central to this mission is our commitment to be transparent about the data we collect about you, how it is used and with whom it is shared.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'This Privacy Policy applies when you use our Services (described below). We offer our users choices about the data we collect, use and share as described in this Privacy Policy, Cookie Policy, Settings and our Help Center.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Table of Contents",
                    style: TextStyle(fontSize: 26),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("1."),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Data We Collect",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 143, 151),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("2."),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "How We Use Your Data",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 143, 151),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("3."),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "How We Share Information",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 143, 151),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("4."),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Your Choices and Obligations",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 143, 151),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("5."),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Other Important Information",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 143, 151),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Introduction",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "We are a social network and online platform \nfor professionals. People use our Services to\nfind and be found for business opportunities, \nto connect with others and find information.  \nOur Privacy Policy applies to any Member or",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Our registered users (“Members”) share their professional identities, engage with their network, exchange knowledge and professional insights, post and view relevant content, learn and develop skills, and find business and career opportunities. Content and data on some of our Services is viewable to non-members (“Visitors”).",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We use the term “Designated Countries” to refer to countries in the European Union (EU), European Economic Area (EEA), and Switzerland.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Service",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "This Privacy Policy, including our Cookie  \nPolicy applies to your use of our Services.",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "This Privacy Policy applies to Recruiter.com, Recruiter-branded apps, Recruiter Learning and other Recruiter-related sites, apps, communications and services (“Services”), including off-site Services, such as our ad services and the “Apply with Recruiter” and “Share with Recruiter” plugins, but excluding services that state that they are offered under a different privacy policy. For California residents, additional disclosures required by California law may be found in our California Privacy Disclosure.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Data Controllers and Contracting Parties",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If you are in the “Designated Countries”, Recruiter Ireland Unlimited Company (“Recruiter Ireland”) will be the controller of your personal data provided to, or collected by or for, or processed in connection with our Services.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If you are outside of the Designated Countries, Recruiter Corporation will be the controller of your personal data provided to, or collected by or for, or processed in connection with, our Services.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "As a Visitor or Member of our Services, the collection, use and sharing of your personal data is subject to this Privacy Policy and other documents referenced in this Privacy Policy, as well as updates.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Change",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Changes to the Privacy Policy apply to your \nuse of our Services after the “effective date.”",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Recruiter (“we” or “us”) can modify this Privacy Policy, and if we make material changes to it, we will provide notice through our Services, or by other means, to provide you the opportunity to review the changes before they become effective. If you object to any changes, you may close your account.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You acknowledge that your continued use of our Services after we publish or send a notice about our changes to this Privacy Policy means that the collection, use and sharing of your personal data is subject to the updated Privacy Policy, as of its effective date.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "1. Data We Collect",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "1.1 Data You Provide To Us",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "You provide data to create an account with us",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Registration",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "To create an account you need to provide data including your name, email address and/or mobile number, general location (e.g., city), and a password. If you register for a premium Service, you will need to provide payment (e.g., credit card) and billing information.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "You create your Recruiter profile (a complete\nprofile helps you get the most from our \nServices).",
                          style: TextStyle(color: Color.fromARGB(154, 0, 0, 0)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You have choices about the information on your profile, such as your education, work experience, skills, photo, city or area and endorsements. You don’t have to provide additional information on your profile; however, profile information helps you to get more from our Services, including helping recruiters and business opportunities find you. It’s your choice whether to include sensitive information on your profile and to make that sensitive information public. Please do not post or add personal data to your profile that you would not want to be publicly available.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "You give other data to us, such as by syncing\n your address book or calendar.",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Posting and Uploading",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '''We collect personal data from you when you provide, post or upload it to our Services, such as when you fill out a form, (e.g., with demographic data or salary), respond to a survey, or submit a resume or fill out a job application on our Services. If you opt to import your address book, we receive your contacts (including contact information your service provider(s) or app automatically added to your address book when you communicated with addresses or numbers not already in your list).

If you sync your contacts or calendars with our Services, we will collect your address book and calendar meeting information to keep growing your network by suggesting connections for you and others, and by providing information about events, e.g. times, places, attendees and contacts.

You don’t have to post or upload personal data; though if you don’t, it may limit your ability to grow and engage with your network over our Services.''',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "1.2 Data From Others",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Others may post or write about you.",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Content and News",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You and others may post content that includes information about you (as part of articles, posts, comments, videos) on our Services. We also may collect public information about you, such as professional-related news and accomplishments, and make it available as part of our Services, including, as permitted by your settings, in notifications to others of mentions in the news.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Others may sync their contacts or calendar\n with our Services",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Contact and Calendar Information",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We receive personal data (including contact information) about you when others import or sync their contacts or calendar with our Services, associate their contacts with Member profiles, scan and upload business cards, or send messages using our Services (including invites or connection requests). If you or others opt-in to sync email accounts with our Services, we will also collect “email header” information that we can associate with Member profiles.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 350,
                    color: Color.fromARGB(37, 85, 143, 151),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_outlined,
                          color: Color.fromARGB(255, 85, 143, 151),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Customers and partners may provide data\n to us.",
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Partners",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We receive personal data (e.g., your job title and work email address) about you when you use the services of our customers and partners, such as employers or prospective employers and applicant tracking systems providing us job application data.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Related Companies and Other Services",
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "We receive data about you when you use some of the other services provided by us or our affiliates, including Microsoft. For example, you may choose to send us information about your contacts in Microsoft apps and services, such as Outlook, for improved professional networking activities on our Services",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
