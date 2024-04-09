class OnboardingContents {
  final String title;
  final String image;
  final String subtitle;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.subtitle,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Find Perfect Job",
    subtitle:
        "Understand your skills and interests, search on JobFinder, tailor applications, network, and stay organized for the perfect job.",
    image: "assets/images/onboard1.jpg",
  ),
  OnboardingContents(
      title: "Apply Your CV",
      subtitle:
          "Summarize experience, detail skills and achievements, include education and certifications, tailor, proofread, and submit.",
      image: "assets/images/onboard2.jpg"
      // "https://img.freepik.com/premium-vector/talent-search-hr-specialist-searching-applicant-using-laptop-human-resources-manager_566886-3759.jpg",
      ),
  OnboardingContents(
    title: "Apply Job",
    subtitle:
        "Prepare your application, find the job posting, read it carefully, and submit following instructions.",
    image: "assets/images/onboard3.jpg",
  ),
  OnboardingContents(
    title: "Post Jobs",
    subtitle:
        "Gather job details, visit job posting platform, input information, review, and publish.",
    image: "assets/images/onboard4.jpg",
  ),
  OnboardingContents(
    title: "Contact Via Message",
    subtitle:
        "Introduce yourself, state purpose, provide details, inquire, close politely.",
    image: "assets/images/onboard5.jpg",
  ),
];
