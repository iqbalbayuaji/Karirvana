import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobOpening {
  final String id;
  final String title;
  final String company;
  final String category;
  final String description;
  final String location;
  final String salary;
  final String type;
  final String level;
  final String postedDate;
  final bool isRemote;

  JobOpening({
    required this.id,
    required this.title,
    required this.company,
    required this.category,
    required this.description,
    required this.location,
    required this.salary,
    required this.type,
    required this.level,
    required this.postedDate,
    required this.isRemote,
  });
}

class JobOpeningsController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'Semua'.obs;
  final isLoading = false.obs;
  
  final allJobs = <JobOpening>[].obs;
  final filteredJobs = <JobOpening>[].obs;

  final filters = [
    'Semua',
    'IT & Programming',
    'Marketing',
    'Design',
    'Sales',
    'Finance',
    'HR & Admin'
  ];

  @override
  void onInit() {
    super.onInit();
    loadJobs();
    
    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterJobs();
    });
    
    // Listen to filter changes
    ever(selectedFilter, (_) => filterJobs());
    ever(searchQuery, (_) => filterJobs());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadJobs() {
    isLoading.value = true;
    
    // Sample job data
    allJobs.value = [
      JobOpening(
        id: '1',
        title: 'Flutter Developer',
        company: 'TechCorp Indonesia',
        category: 'IT & Programming',
        description: 'Mengembangkan aplikasi mobile menggunakan Flutter framework',
        location: 'Jakarta',
        salary: 'Rp 8.000.000 - 12.000.000',
        type: 'Full Time',
        level: 'Mid Level',
        postedDate: '2 hari yang lalu',
        isRemote: true,
      ),
      JobOpening(
        id: '2',
        title: 'UI/UX Designer',
        company: 'Creative Studio',
        category: 'Design',
        description: 'Merancang antarmuka pengguna yang menarik dan fungsional',
        location: 'Bandung',
        salary: 'Rp 6.000.000 - 9.000.000',
        type: 'Full Time',
        level: 'Junior Level',
        postedDate: '1 hari yang lalu',
        isRemote: false,
      ),
      JobOpening(
        id: '3',
        title: 'Digital Marketing Specialist',
        company: 'Marketing Pro',
        category: 'Marketing',
        description: 'Mengelola kampanye digital marketing dan social media',
        location: 'Surabaya',
        salary: 'Rp 5.000.000 - 8.000.000',
        type: 'Full Time',
        level: 'Mid Level',
        postedDate: '3 hari yang lalu',
        isRemote: true,
      ),
      JobOpening(
        id: '4',
        title: 'Sales Executive',
        company: 'Global Sales Inc',
        category: 'Sales',
        description: 'Mengembangkan dan memelihara hubungan dengan klien',
        location: 'Jakarta',
        salary: 'Rp 4.500.000 - 7.000.000',
        type: 'Full Time',
        level: 'Entry Level',
        postedDate: '1 minggu yang lalu',
        isRemote: false,
      ),
      JobOpening(
        id: '5',
        title: 'Financial Analyst',
        company: 'Finance Solutions',
        category: 'Finance',
        description: 'Menganalisis data keuangan dan membuat laporan',
        location: 'Jakarta',
        salary: 'Rp 7.000.000 - 10.000.000',
        type: 'Full Time',
        level: 'Mid Level',
        postedDate: '5 hari yang lalu',
        isRemote: true,
      ),
      JobOpening(
        id: '6',
        title: 'HR Generalist',
        company: 'People First',
        category: 'HR & Admin',
        description: 'Mengelola proses rekrutmen dan administrasi karyawan',
        location: 'Yogyakarta',
        salary: 'Rp 5.500.000 - 8.500.000',
        type: 'Full Time',
        level: 'Mid Level',
        postedDate: '4 hari yang lalu',
        isRemote: false,
      ),
    ];
    
    filteredJobs.value = allJobs;
    isLoading.value = false;
  }

  void filterJobs() {
    List<JobOpening> filtered = allJobs;
    
    // Filter by category
    if (selectedFilter.value != 'Semua') {
      filtered = filtered.where((job) => 
        job.category == selectedFilter.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((job) =>
        job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        job.company.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        job.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        job.location.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    filteredJobs.value = filtered;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
