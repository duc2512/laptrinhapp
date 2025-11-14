# 📱 DUC_SEARCH_FUNCTIONALITY - UI/LAYOUT CODE SHOWCASE

---

## 🎯 TỔNG QUAN CẤU TRÚC UI

```
SearchScreen (Main Screen)
├── AppBar (Gradient Blue-Cyan)
│   ├── Title: "Tìm kiếm"
│   ├── Action: Filter Icon (Advanced Search)
│   └── TabBar: [Người mượn] [Sách] (Admin only)
│
├── SearchBarWidget
│   └── TextField with Search Icon & Clear Button
│
└── Content Area
    ├── SearchHistoryWidget (Lịch sử tìm kiếm)
    ├── SearchResultCardWidget (Kết quả tìm kiếm người mượn)
    └── BookResultCardWidget (Kết quả tìm kiếm sách)
```

---

## 1️⃣ SEARCH SCREEN (Main Container)

### **AppBar Style**
### **AppBar Style - Thanh tiêu đề**
```dart
AppBar(
### **Card Layout for Borrow Records - Layout card cho bản ghi mượn**
```dart
  flexibleSpace: Container(
  final BorrowCard card;  // Dữ liệu card mượn sách
  final String query;  // Từ khóa tìm kiếm (để highlight)
  final HighlightTarget highlightTarget;  // Nên highlight field nào
        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
        // Cyan → Blue (màu xanh dương gradient)
      ),
    final dateFormat = DateFormat('dd/MM/yyyy');  // Định dạng ngày
  ),
  title: const Text('Tìm kiếm'),  // Tiêu đề "Tìm kiếm"
      margin: const EdgeInsets.only(bottom: 12),  // Khoảng cách dưới card
      elevation: 2,  // Shadow card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),  // Góc cong 12px
        tooltip: 'Tìm kiếm nâng cao',  // Tooltip khi hover
        icon: const Icon(Icons.filter_alt_outlined),  // Icon lọc
        // Cho phép nhấn card
        onPressed: () {
          // Khi tap: mở màn hình chi tiết
          // Lấy SearchBloc từ context hiện tại
          final searchBloc = context.read<SearchBloc>();
          // Mở dialog tìm kiếm nâng cao
          showDialog(
            context: context,
            builder: (dialogContext) => BlocProvider<SearchBloc>.value(
              value: searchBloc,  // Cung cấp SearchBloc cho dialog
              child: const AdvancedSearchDialog(),
            ),
        borderRadius: BorderRadius.circular(12),  // Góc cong khi tap
        },
          padding: const EdgeInsets.all(16),  // Khoảng cách nội dung
  ],
  // TabBar: Hiển thị 2 tab (Người mượn/Sách) cho Admin, không có cho User
  bottom: PermissionHelper.isRegularUser(_currentUser)
              // 📚 Tên sách (với icon)
      : TabBar(
          controller: _tabController,  // Điều khiển tab
          indicatorColor: Colors.white,  // Màu indicator (gạch dưới) trắng
          tabs: const [
                    color: Color(0xFF06B6D4),  // Màu cyan
                    size: 20,  // Kích thước icon
          ],
                  const SizedBox(width: 8),  // Khoảng cách giữa icon và text
)
```

                      // Chỉ highlight tên sách khi target bao gồm book
### **Main Body Layout - Bố cục chính**
```dart
Scaffold(
  backgroundColor: Colors.grey[50],  // Màu nền xám nhạt
  appBar: /* ... */,
  ### **Dialog Footer (Action Buttons) - Footer dialog với nút hành động**
  ```dart
                        fontWeight: FontWeight.bold,  // Text đậm
    padding: const EdgeInsets.all(20),  // Khoảng cách 20px xung quanh
      // 1. Search Bar Container - Hộp chứa thanh tìm kiếm
      color: Colors.grey[50],  // Nền xám rất nhạt
        color: Colors.white,  // Nền trắng
        bottomLeft: Radius.circular(16),  // Góc cong dưới trái
        bottomRight: Radius.circular(16),  // Góc cong dưới phải
          controller: _searchController,  // Điều khiển TextField
              // 👤 Thông tin người mượn (với icon)
          onClear: _onClearSearch,  // Callback khi nhấn clear
          // Hint text thay đổi theo user loại và tab
          hintText: PermissionHelper.isRegularUser(_currentUser)
              ? 'Tìm theo tên sách...'  // Người dùng thường: tìm sách
            // Nút "Xóa bộ lọc"
                    color: Colors.grey,  // Màu xám
            child: const Text('Xóa bộ lọc'),  // Text nút
                  : 'Tìm theo tên sách...'),  // Tab 1: tìm sách
                  const SizedBox(width: 8),  // Khoảng cách
        const SizedBox(width: 12),  // Khoảng cách giữa 2 nút

      // 2. Content Area (Expanded) - Khu vực nội dung chính
            // Nút "Tìm kiếm" (nút chính)
                      // Kết hợp tên và lớp
                      // Chỉ highlight người mượn khi target bao gồm borrower
              backgroundColor: const Color(0xFF06B6D4),  // Màu cyan
        child: BlocConsumer<SearchBloc, SearchState>(
            child: const Text('Tìm kiếm'),  // Text nút
          listener: (context, state) {
            // Khi lịch sử được tải, cập nhật local state
            if (state is SearchHistoryLoaded) {
                        color: Colors.grey[700],  // Màu xám đậm
                _searchHistory = state.history;
              });
            }
          },
          // Builder: Xây dựng UI dựa trên state (rebuild khi state thay đổi)
              const SizedBox(height: 8),  // Khoảng cách
            // Hiển thị UI khác nhau tùy theo state hiện tại
              // 📅 Ngày mượn và trả (với icon)
              return _buildInitialState();  // Trạng thái ban đầu
            } else if (state is SearchLoading) {
              return _buildLoadingState();  // Đang tải (spinner)
            } else if (state is SearchLoaded) {
                    color: Colors.grey,  // Màu xám
                    size: 16,  // Kích thước nhỏ
              return _buildEmptyState(state.query);  // Không có kết quả
                  const SizedBox(width: 8),  // Khoảng cách
              return _buildErrorState(state.message);  // Xảy ra lỗi
                    'Mượn: ${dateFormat.format(card.borrowDate)}',  // Ngày mượn
            return _buildInitialState();  // Mặc định: trạng thái ban đầu
          },
                      color: Colors.grey[600],  // Màu xám nhạt
      ),
    ],
                  const SizedBox(width: 16),  // Khoảng cách lớn giữa hai ngày
)
```
                    color: Colors.grey,  // Màu xám
                    size: 16,  // Kích thước nhỏ

                  const SizedBox(width: 8),  // Khoảng cách

                    'Trả: ${dateFormat.format(card.expectedReturnDate)}',  // Ngày trả dự kiến
### **Custom TextField with Icons - TextField tùy chỉnh với icon**
```dart
                      color: Colors.grey[600],  // Màu xám nhạt
  final TextEditingController controller;  // Điều khiển nội dung text
  final ValueChanged<String> onChanged;  // Callback khi text thay đổi
  final VoidCallback onClear;  // Callback khi clear text
  ✅ **Gradient AppBar** - Gradient hiện đại cyan sang blue
  final String hintText;  // Text gợi ý
  ✅ **Rounded Cards** - Border radius 12px cho vẻ mềm mại
              const SizedBox(height: 12),  // Khoảng cách trước badge
  ✅ **Status Badges** - Badge theo màu (xanh/đỏ/xanh dương) với icon
  @override
  ✅ **Dynamic Highlighting** - Nền vàng với text dễ đọc
              // 🏷️ Badge trạng thái
  ✅ **Tab Navigation** - Tab Người mượn/Sách cho admin
    return TextField(
  ✅ **Search Bar** - Góc cong với nút clear & focus color
      controller: controller,  // Gán controller
  ✅ **Search History** - Layout wrap với ActionChip
      onChanged: onChanged,  // Gác lắng nghe thay đổi text
  ✅ **Advanced Dialog** - Form nhiều tiêu chí với date picker
      decoration: InputDecoration(
  ✅ **Empty States** - Icon + thông báo hữu ích cho tất cả state
        hintText: hintText,  // Text gợi ý ban đầu
  ✅ **Cache Indicator** - Badge xanh cho kết quả từ cache
        prefixIcon: const Icon(Icons.search_rounded),  // Icon tìm kiếm bên trái
  ✅ **Form Validation** - Tối thiểu 1 tiêu chí cần điền
        
        // Nút clear (chỉ hiện khi có text)
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),  // Icon X
  - **Single Column Layout** - Thích ứng với tất cả kích thước màn hình
  - **Flexible Widgets** - Dùng Expanded để phân bổ không gian hợp lý
  - **ListView Builders** - Render hiệu quả cho danh sách lớn
  - **SingleChildScrollView** - Tránh overflow trên màn hình nhỏ
        // Định dạng border (viền)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Góc cong 12px
          borderSide: BorderSide(color: Colors.grey[300]!),  // Màu xám nhạt
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),  // Border khi bình thường
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF06B6D4),  // Màu cyan khi focus
            width: 2,  // Dày hơn khi focus
          ),
        ),
        
        // Nền và khoảng cách nội dung
        filled: true,  // Cho phép đổi màu nền
        fillColor: Colors.white,  // Màu nền trắng
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,  // Khoảng cách 16px trái-phải
          vertical: 12,  // Khoảng cách 12px trên-dưới
        ),
      ),
    );
  }
}
```

**Style Features:**
**Style Features - Đặc điểm thiết kế:**
- ✅ Rounded corners (12px)
- ✅ Rounded corners (12px) - Góc cong mềm mại
- ✅ Cyan focus color (#06B6D4)
- ✅ Cyan focus color (#06B6D4) - Màu xanh dương khi focus
- ✅ Search icon prefix
- ✅ Search icon prefix - Icon tìm kiếm bên trái
- ✅ Clear button suffix (dynamic)
- ✅ Clear button suffix (dynamic) - Nút clear động (chỉ hiện khi có text)
- ✅ Light grey border
- ✅ Light grey border - Viền xám nhạt

---

## 3️⃣ INITIAL STATE (No Search)

### **Empty Screen with Icon & Message**
### **Empty Screen with Icon & Message - Màn hình rỗng với icon và thông báo**
```dart
Widget _buildInitialState() {
  return SingleChildScrollView(  // Cho phép cuộn nếu nội dung quá dài
    child: Column(
      children: [
        // Hiển thị lịch sử tìm kiếm nếu có
        if (_searchHistory.isNotEmpty)
          SearchHistoryWidget(
            history: _searchHistory,  // Danh sách lịch sử
            onHistoryTap: _onHistoryTap,  // Callback khi tap lịch sử
            onClearHistory: _onClearHistory,  // Callback xóa lịch sử
          ),

        // Thông báo ban đầu
        Padding(
          padding: const EdgeInsets.all(32),  // Khoảng cách 32px xung quanh
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa theo trục dọc
            children: [
              Icon(
                Icons.search_rounded,  // Icon tìm kiếm lớn
                size: 80,  // Kích thước 80px
                color: Colors.grey[300],  // Màu xám nhạt
              ),
              const SizedBox(height: 16),  // Khoảng cách 16px
              Text(
                'Nhập từ khóa để tìm kiếm',
                // Tiêu đề
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],  // Màu xám đậm
                ),
              ),
              const SizedBox(height: 8),  // Khoảng cách nhỏ
              Text(
                // Thay đổi text tùy theo tab (Người mượn hay Sách)
                _tabController.index == 0
                    ? 'Tìm kiếm theo tên người mượn'
                    : 'Tìm kiếm theo tên sách',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],  // Màu xám nhạt hơn
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

---

## 4️⃣ LOADING STATE

### **Spinner Center**
```dart
Widget _buildLoadingState() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
```

---

## 5️⃣ RESULTS LIST

### **Header with Count & Cache Badge**
```dart
Widget _buildResultsList(SearchLoaded state) {
  return Column(
    children: [
      // Header
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Text(
              'Tìm thấy ${state.totalResults} kết quả',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            
            // Cache indicator badge
            if (state.fromCache) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                  ### **Spinner Center - Hiệu ứng loading ở giữa màn hình**
                  ```dart
                  mainAxisSize: MainAxisSize.min,
                    return const Center(  // Căn giữa nội dung
                      child: CircularProgressIndicator(),  // Vòng xoay loading (spinner)
                      Icons.cached,
                      size: 14,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cached',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                         // Header - phần tiêu đề
              ),
                           padding: const EdgeInsets.all(16),  // Khoảng cách 16px
                           color: Colors.white,  // Nền trắng
        ),
      ),

      // Results ListView
                                  // Hiển thị số kết quả
      Expanded(
                                  // Text đậm
        child: ListView.builder(
                               // Badge cache (hiển thị nếu kết quả từ cache)
          itemCount: state.results.length,
                                 const SizedBox(width: 8),  // Khoảng cách giữa text và badge
            final highlightTarget = _tabController.index == 0
                ? HighlightTarget.borrower
                                     horizontal: 8,  // Khoảng cách trong badge (trái-phải)
                                     vertical: 4,  // Khoảng cách trong badge (trên-dưới)
            return SearchResultCardWidget(
              card: state.results[index],
                                     color: Colors.green[50],  // Nền xanh nhạt
                                     borderRadius: BorderRadius.circular(12),  // Góc cong
            );
          },
                                     mainAxisSize: MainAxisSize.min,  // Chiều rộng vừa đủ
      ),
    ],
                                         Icons.cached,  // Icon cache
                                         size: 14,  // Kích thước nhỏ
                                         color: Colors.green[700],  // Màu xanh đậm

                                       const SizedBox(width: 4),  // Khoảng cách 4px

                                         'Cached',  // Text "Cached"

                                           fontSize: 11,  // Font nhỏ
                                           color: Colors.green[700],  // Màu xanh đậm
Widget _buildEmptyState(String query) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
                         // Danh sách kết quả
          ),
                           // Chiếm hết không gian còn lại
          const SizedBox(height: 16),
                             padding: const EdgeInsets.all(16),  // Khoảng cách 16px
                             itemCount: state.results.length,  // Số item = số kết quả
            style: TextStyle(
                               // Xác định nên highlight field nào dựa trên tab hiện tại
                               // Tab 0 = Người mượn, Tab 1 = Sách
              fontWeight: FontWeight.w600,
                                   ? HighlightTarget.borrower  // Highlight tên người mượn
                                   : HighlightTarget.book;  // Highlight tên sách
          ),
                               // Xây dựng card kết quả
          const SizedBox(height: 8),
                                 card: state.results[index],  // Dữ liệu card
                                 query: state.query,  // Từ khóa tìm kiếm (để highlight)
                                 highlightTarget: highlightTarget,  // Loại highlight
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
```

---

## 7️⃣ ERROR STATE

                    return Center(  // Căn giữa nội dung
                      child: Padding(
                        padding: const EdgeInsets.all(32),  // Khoảng cách 32px xung quanh
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa theo trục dọc
      padding: const EdgeInsets.all(32),
      child: Column(
                              Icons.search_off_rounded,  // Icon tìm kiếm bị gạch
                              size: 80,  // Kích thước lớn
                              color: Colors.grey[300],  // Màu xám nhạt
            Icons.error_outline_rounded,
                            const SizedBox(height: 16),  // Khoảng cách 16px
            color: Colors.red[300],
          ),
                              // Tiêu đề
          const SizedBox(height: 16),
          Text(
                                fontWeight: FontWeight.w600,  // Text đậm
                                color: Colors.grey[700],  // Màu xám đậm
              fontSize: 18,
              fontWeight: FontWeight.w600,
                            const SizedBox(height: 8),  // Khoảng cách nhỏ
            ),
          ),
                              // Thông báo chi tiết (hiển thị từ khóa)
          const SizedBox(height: 8),
          Text(
                                color: Colors.grey[600],  // Màu xám
            style: TextStyle(
                              textAlign: TextAlign.center,  // Căn giữa text
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _onSearchChanged(_searchController.text);
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
                    return Center(  // Căn giữa nội dung
                      child: Padding(
                        padding: const EdgeInsets.all(32),  // Khoảng cách 32px xung quanh
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa theo trục dọc

---
                              Icons.error_outline_rounded,  // Icon lỗi
                              size: 80,  // Kích thước lớn
                              color: Colors.red[300],  // Màu đỏ nhạt
### **Card Layout for Borrow Records**
                            const SizedBox(height: 16),  // Khoảng cách 16px
class SearchResultCardWidget extends StatelessWidget {
  final BorrowCard card;
                              // Tiêu đề
  final String query;
  final HighlightTarget highlightTarget;
                                fontWeight: FontWeight.w600,  // Text đậm
                                color: Colors.grey[700],  // Màu xám đậm
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
                            const SizedBox(height: 8),  // Khoảng cách nhỏ
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
                              // Thông báo lỗi chi tiết (từ server)
      elevation: 2,
      shape: RoundedRectangleBorder(
                                color: Colors.grey[600],  // Màu xám
      ),
                              textAlign: TextAlign.center,  // Căn giữa text
        onTap: () {
                            const SizedBox(height: 24),  // Khoảng cách lớn
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                                // Thử lại tìm kiếm với từ khóa cũ
                create: (context) => getIt<BorrowBloc>(),
                child: BorrowDetailScreen(borrowCard: card),
              ),
            ),
                               icon: const Icon(Icons.refresh),  // Icon làm mới
                               label: const Text('Thử lại'),  // Text nút
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📚 Book Name (with icon)
              Row(
                children: [
                  const Icon(
                    Icons.book_rounded,
                    color: Color(0xFF06B6D4),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildHighlightedText(
                      card.bookName,
                      (highlightTarget == HighlightTarget.book ||
                              highlightTarget == HighlightTarget.both)
                          ? query
                          : '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 👤 Borrower Info (with icon)
              Row(
                children: [
                  const Icon(
                    Icons.person_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildHighlightedText(
                      '${card.borrowerName}${card.borrowerClass != null ? ' - ${card.borrowerClass}' : ''}',
                      (highlightTarget == HighlightTarget.borrower ||
                              highlightTarget == HighlightTarget.both)
                          ? query
                          : '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 📅 Dates
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mượn: ${dateFormat.format(card.borrowDate)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.event_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trả: ${dateFormat.format(card.expectedReturnDate)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 🏷️ Status Badge
              _buildStatusBadge(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **Status Badge**
### **Status Badge - Badge hiển thị trạng thái**
```dart
Widget _buildStatusBadge() {
  Color color;  // Màu badge
  String text;  // Text hiển thị
  IconData icon;  // Icon hiển thị

  if (card.status == BorrowStatus.returned) {  // Nếu đã trả sách
    color = Colors.green;  // Màu xanh
    text = 'Đã trả';  // Text "Đã trả"
    icon = Icons.check_circle_rounded;  // Icon tick
  } else if (card.isOverdue) {  // Nếu quá hạn
    color = Colors.red;  // Màu đỏ
    text = 'Quá hạn ${card.daysOverdue} ngày';  // Text quá hạn
    icon = Icons.warning_rounded;  // Icon cảnh báo
  } else {  // Đang mượn
    color = Colors.blue;  // Màu xanh dương
    text = 'Đang mượn';  // Text "Đang mượn"
    icon = Icons.schedule_rounded;  // Icon lịch
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),  // Khoảng cách nội dung
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),  // Nền màu với độ trong suốt
      borderRadius: BorderRadius.circular(20),  // Góc cong 20px (viên) thuốc
      border: Border.all(color: color.withOpacity(0.3)),  // Viền cùng màu
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,  // Chiều rộng vừa đủ
      children: [
        Icon(icon, color: color, size: 16),  // Icon
        const SizedBox(width: 6),  // Khoảng cách nhỏ
        Text(
          text,
          style: TextStyle(
            color: color,  // Màu text = màu badge
            fontSize: 12,  // Font nhỏ
            fontWeight: FontWeight.w600,  // Text đậm
          ),
        ),
      ],
    ),
  );
}
```

### **Highlighted Text (Diacritics-Insensitive)**
```dart
Widget _buildHighlightedText(
  String text,  // Text cần hiển thị
  String query, {  // Từ khóa tìm kiếm (nếu không empty thì highlight)
  TextStyle? style,  // Style tùy chỉnh cho text
}) {
  if (query.isEmpty) {  // Nếu query rỗng: không highlight
    return Text(
      text,
      style: style ?? const TextStyle(color: Colors.black87),  // Style hoặc mặc định
    );
  }

  final lowerText = text.toLowerCase();  // Chuyển text thành chữ thường
  final lowerQuery = query.toLowerCase().trim();  // Chuyển query thành chữ thường
  final index = lowerText.indexOf(lowerQuery);  // Tìm vị trí khớp đầu tiên

  if (index == -1) {  // Không tìm thấy: hiển thị bình thường
    return Text(
      text,
      style: style ?? const TextStyle(color: Colors.black87),  // Style hoặc mặc định
    );
  }

  // Đảm bảo màu text dễ đọc
  final Color textColor = style?.color ?? Colors.black87;  // Lấy màu từ style hoặc mặc định
  final defaultStyle = (style ?? const TextStyle()).copyWith(
    color: textColor,  // Sao chép style với màu đã chọn
  );

  return RichText(
    text: TextSpan(
      style: defaultStyle,  // Style chung
      children: [
        TextSpan(text: text.substring(0, index)),  // Phần trước khớp
        
        // ✨ Phần khớp với highlight (nền vàng)
        TextSpan(
          text: text.substring(index, index + query.length),  // Phần khớp
          style: defaultStyle.copyWith(
            backgroundColor: Colors.yellow[200],  // Nền vàng nhạt
            fontWeight: FontWeight.bold,  // Text đậm
            color: defaultStyle.color,  // Giữ nguyên màu text
          ),
        ),
        
        TextSpan(text: text.substring(index + query.length)),  // Phần sau khớp
      ],
    ),
  );
}
```

---

## 9️⃣ SEARCH HISTORY WIDGET

### **Recent Searches as Chips**
### **Recent Searches as Chips - Lịch sử tìm kiếm dưới dạng chip**
```dart
class SearchHistoryWidget extends StatelessWidget {
  final List<String> history;  // Danh sách lịch sử tìm kiếm
  final ValueChanged<String> onHistoryTap;  // Callback khi tap lịch sử
  final VoidCallback onClearHistory;  // Callback xóa tất cả lịch sử

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {  // Nếu lịch sử trống: không hiển thị
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),  // Khoảng cách 16px xung quanh
      color: Colors.white,  // Nền trắng
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với nút xóa
          Row(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 20,  // Kích thước icon
                color: Colors.grey,  // Màu xám
              ),
              const SizedBox(width: 8),  // Khoảng cách
              const Text(
                'Tìm kiếm gần đây',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,  // Text đậm
                  color: Colors.grey,  // Màu xám
                ),
              ),
              const Spacer(),  // Đẩy nút sang phải
              TextButton(
                onPressed: onClearHistory,
                child: const Text(
                  'Xóa tất cả',
                  style: TextStyle(fontSize: 12),  // Font nhỏ
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),  // Khoảng cách trước chips

          // Chip lịch sử (Wrap layout)
          Wrap(
            spacing: 8,  // Khoảng cách ngang giữa chip
            runSpacing: 8,  // Khoảng cách dọc giữa hàng chip
            children: history.map((query) {
              return ActionChip(
                label: Text(query),  // Tên chip = từ khóa
                onPressed: () => onHistoryTap(query),  // Tap chip: tìm lại
                avatar: const Icon(Icons.history, size: 16),  // Icon trái
                backgroundColor: Colors.grey[100],  // Nền xám nhạt
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔟 BOOK RESULT CARD WIDGET

### **Book Search Results Card**
```dart
class BookResultCardWidget extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📚 Title Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (book.author != null &&
                            book.author!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Tác giả: ${book.author}',
                            style: TextStyle(
                            ### **Book Search Results Card - Card kết quả tìm sách**
                            ```dart
                              color: Colors.grey[600],
                              final Book book;  // Dữ liệu sách
                              final VoidCallback? onTap;  // Callback khi nhấn card
                        ],
                      ],
                    ),
                  ),
                                  margin: const EdgeInsets.only(bottom: 12),  // Khoảng cách dưới card
                                  elevation: 2,  // Shadow card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),  // Góc cong 12px
              const Divider(height: 1),
              const SizedBox(height: 12),
                                    onTap: onTap,  // Callback khi tap
                                    borderRadius: BorderRadius.circular(12),  // Góc cong khi tap
              Row(
                                      padding: const EdgeInsets.all(16),  // Khoảng cách nội dung
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.category_outlined,
                                          // 📚 Phần tiêu đề sách
                      value: book.category ?? 'Chưa phân loại',
                    ),
                  ),
                                                padding: const EdgeInsets.all(8),  // Khoảng cách trong container
                  Expanded(
                                                  color: Colors.blue.shade50,  // Nền xanh nhạt
                                                  borderRadius: BorderRadius.circular(8),  // Góc cong nhỏ
                      label: 'Mã sách',
                      value: book.bookCode,
                    ),
                                                  color: Colors.blue.shade700,  // Icon xanh đậm
                                                  size: 24,  // Kích thước icon
              ),

                                              const SizedBox(width: 12),  // Khoảng cách giữa icon và text

              // 📦 Availability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                                                      // Tên sách
                    children: [
                      Icon(
                                                        fontWeight: FontWeight.bold,  // Text đậm
                                                        color: Colors.black87,  // Màu text
                        color: Colors.grey[600],
                                                      maxLines: 2,  // Tối đa 2 dòng
                                                      overflow: TextOverflow.ellipsis,  // Cắt ngang (...)
                      Text(
                                                    if (book.author != null &&  // Nếu có tác giả
                                                        book.author!.isNotEmpty) ...[
                                                      const SizedBox(height: 4),  // Khoảng cách nhỏ
                          color: Colors.grey[600],
                        ),
                                                        // Tên tác giả
                      ),
                    ],
                                                          color: Colors.grey[600],  // Màu xám nhạt
                  _buildAvailabilityChip(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
                                          const SizedBox(height: 12),  // Khoảng cách lớn
                                          const Divider(height: 1),  // Đường kẻ ngăn cách
                                          const SizedBox(height: 12),  // Khoảng cách lớn
    required IconData icon,
                                          // 📋 Hàng chi tiết (Thể loại + Mã sách)
    required String value,
  }) {
    return Row(
      children: [
                                                  icon: Icons.category_outlined,  // Icon thể loại
                                                  label: 'Thể loại',  // Nhãn
                                                  value: book.category ?? 'Chưa phân loại',  // Giá trị
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                                              const SizedBox(width: 16),  // Khoảng cách giữa 2 cột
              Text(
                label,
                                                  icon: Icons.qr_code_rounded,  // Icon QR
                                                  label: 'Mã sách',  // Nhãn
                                                  value: book.bookCode,  // Giá trị
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                                          const SizedBox(height: 12),  // Khoảng cách
                  fontWeight: FontWeight.w500,
                                          // 📦 Tình trạng có sách
                maxLines: 1,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Đẩy 2 phần ra 2 đầu
              ),
            ],
          ),
        ),
      ],
                                                    size: 16,  // Kích thước icon
                                                    color: Colors.grey[600],  // Màu xám

                                                  const SizedBox(width: 4),  // Khoảng cách nhỏ
  Widget _buildAvailabilityChip() {
    final isAvailable = book.availableCopies > 0;
                                                    // Tổng số cuốn
    final color = isAvailable ? Colors.green : Colors.red;
    final text = isAvailable
                                                      color: Colors.grey[600],  // Màu xám
        : 'Hết sách';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              _buildAvailabilityChip(),  // Chip trạng thái sẵn có
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
                              Widget _buildInfoItem({  // Helper: xây dựng item thông tin
                                required IconData icon,  // Icon
                                required String label,  // Nhãn (tên field)
                                required String value,  // Giá trị
          Text(
            text,
            style: TextStyle(
                                    Icon(icon, size: 16, color: Colors.grey[600]),  // Icon nhỏ
                                    const SizedBox(width: 4),  // Khoảng cách nhỏ
              color: color,
            ),
          ),
        ],
      ),
    );
                                            // Nhãn
  }
}
                                              color: Colors.grey[500],  // Màu xám nhạt (secondary text)

---

## 1️⃣1️⃣ ADVANCED SEARCH DIALOG
                                            // Giá trị

### **Dialog Header (Gradient)**
                                              fontWeight: FontWeight.w500,  // Text bán đậm
// Header with gradient
                                            maxLines: 1,  // Tối đa 1 dòng
                                            overflow: TextOverflow.ellipsis,  // Cắt ngang (...)
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      ### **Dialog Header (Gradient) - Header dialog với gradient**
      ```dart
                              Widget _buildAvailabilityChip() {  // Helper: xây dựng chip trạng thái
                                final isAvailable = book.availableCopies > 0;  // Kiểm tra có sách
        padding: const EdgeInsets.all(20),  // Khoảng cách 20px xung quanh
      const Icon(Icons.filter_list, color: Colors.white),
                                    ? 'Còn ${book.availableCopies} cuốn'  // Nếu còn: hiển thị số lượng
                                    : 'Hết sách';  // Nếu hết: hiển thị "Hết sách"
            // Gradient cyan → blue
        'Tìm kiếm nâng cao',
        style: TextStyle(
            topLeft: Radius.circular(16),  // Góc cong trên trái
            topRight: Radius.circular(16),  // Góc cong trên phải
                                    color: color.withOpacity(0.1),  // Nền màu nhạt với độ trong suốt
                                    borderRadius: BorderRadius.circular(20),  // Góc cong viên thuốc
                                    border: Border.all(color: color.withOpacity(0.3)),  // Viền cùng màu
      const Spacer(),
            const Icon(Icons.filter_list, color: Colors.white),  // Icon lọc trắng
            const SizedBox(width: 12),  // Khoảng cách
        icon: const Icon(Icons.close, color: Colors.white),
      ),
              // Tiêu đề dialog
                                        isAvailable ? Icons.check_circle : Icons.cancel,  // Icon check/X
                                        size: 14,  // Kích thước nhỏ
                fontSize: 18,  // Font lớn
                fontWeight: FontWeight.bold,  // Text đậm
                                      const SizedBox(width: 4),  // Khoảng cách nhỏ
### **Form Fields**
            const Spacer(),  // Đẩy nút X sang phải
Flexible(
  child: SingleChildScrollView(
              icon: const Icon(Icons.close, color: Colors.white),  // Nút đóng
                                          color: color,  // Màu text = màu chip
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Helper text
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
         // Chiếm không gian còn lại, cho phép cuộn
        child: SingleChildScrollView(  // Cho phép cuộn nếu form dài
          padding: const EdgeInsets.all(20),  // Khoảng cách 20px
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
                // Text hỗ trợ (hướng dẫn)

                  padding: const EdgeInsets.only(bottom: 16),  // Khoảng cách dưới
          TextField(
            controller: _borrowerNameController,
                    // Text hướng dẫn
            decoration: const InputDecoration(
              labelText: 'Tên người mượn',
                      // Font nhỏ
                      color: Colors.grey[600],  // Màu xám
                      fontStyle: FontStyle.italic,  // Chữ nghiêng
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
                // Tên người mượn
          // Book Name
          TextField(
            controller: _bookNameController,
            decoration: const InputDecoration(
                    hintText: 'Nhập tên người mượn',  // Text gợi ý
                    prefixIcon: Icon(Icons.person_rounded),  // Icon người
              prefixIcon: Icon(Icons.book_rounded),
              border: OutlineInputBorder(),
            ),
                const SizedBox(height: 16),  // Khoảng cách giữa field
          const SizedBox(height: 16),
                // Tên sách
          // Class
          TextField(
            controller: _classController,
            decoration: const InputDecoration(
                    hintText: 'Nhập tên sách',  // Text gợi ý
                    prefixIcon: Icon(Icons.book_rounded),  // Icon sách
              prefixIcon: Icon(Icons.school_rounded),
              border: OutlineInputBorder(),
            ),
                const SizedBox(height: 16),  // Khoảng cách
          const SizedBox(height: 16),
                // Lớp
          // Status Dropdown
          DropdownButtonFormField<BorrowStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
                    hintText: 'Nhập lớp',  // Text gợi ý
                    prefixIcon: Icon(Icons.school_rounded),  // Icon trường
              border: OutlineInputBorder(),
            ),
            items: [
                const SizedBox(height: 16),  // Khoảng cách
                value: null,
                // Dropdown trạng thái
              ),
              ...BorrowStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                    prefixIcon: Icon(Icons.info_rounded),  // Icon thông tin
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                      child: Text('Tất cả'),  // Option tất cả
              });
                    // Map tất cả status enum sang option
            },
          ),
          const SizedBox(height: 20),
                        // Hiển thị text tiếng Việt

          // Borrow Date Range
          const Text(
            'Ngày mượn',
                  onChanged: (value) {  // Callback khi chọn
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
                const SizedBox(height: 20),  // Khoảng cách lớn trước section tiếp theo
            children: [
                // Khoảng ngày mượn
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(
                  // Tiêu đề section
                    context,
                    _borrowDateFrom,
                    fontSize: 14,  // Font medium
                  ),
                  icon: const Icon(Icons.calendar_today, size: 16),
                const SizedBox(height: 8),  // Khoảng cách nhỏ
                    _borrowDateFrom != null
                        ? dateFormat.format(_borrowDateFrom!)
                        : 'Từ ngày',
                  ),
                ),
              ),
              const SizedBox(width: 8),
                          (date) => setState(() => _borrowDateFrom = date),  // Cập nhật date
                child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),  // Icon lịch nhỏ
                    context,
                    _borrowDateTo,
                    (date) => setState(() => _borrowDateTo = date),
                              : 'Từ ngày',  // Placeholder
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    _borrowDateTo != null
                    const SizedBox(width: 8),  // Khoảng cách giữa 2 button
                        : 'Đến ngày',
                  ),
                ),
              ),
            ],
                          (date) => setState(() => _borrowDateTo = date),  // Cập nhật date
          const SizedBox(height: 16),
                        icon: const Icon(Icons.calendar_today, size: 16),  // Icon lịch nhỏ
          // Return Date Range (similar structure)
          // ... (same pattern as borrow date range)
        ],
                              : 'Đến ngày',  // Placeholder
    ),
  ),
)
```

                const SizedBox(height: 16),  // Khoảng cách
```dart
                // Khoảng ngày trả dự kiến (cấu trúc tương tự)
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.grey[50],
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    ),
  ),
  child: Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: _clearFilters,
          child: const Text('Xóa bộ lọc'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton(
          onPressed: _applySearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF06B6D4),
          ),
          child: const Text('Tìm kiếm'),
        ),
      ),
    ],
  ),
)
```

---

## 🎨 COLOR SCHEME & STYLING

| Element | Color | HEX Code |
|---------|-------|---------|
| **Primary Gradient** | Cyan → Blue | #06B6D4 → #3B82F6 |
| **Success** | Green | #22C55E |
| **Error/Overdue** | Red | #EF4444 |
| **Info** | Blue | #3B82F6 |
| **Background** | Light Grey | #F9FAFB |
| **Text Primary** | Dark Grey | #000000 |
| **Text Secondary** | Grey | #6B7280 |
| **Border** | Light Grey | #D1D5DB |
| **Highlight** | Yellow | #FBBF24 |

---

## 📐 SPACING & SIZING

| Element | Size |
|---------|------|
| **Icon Size** | 16-80px |
| **Border Radius** | 8-12px (cards) |
| **Padding (Cards)** | 16px |
| **Padding (Screen)** | 16-32px |
| **Font Size (Title)** | 18px |
| **Font Size (Body)** | 13-16px |
| **Gap (SizedBox)** | 4-24px |

---

## ✨ KEY UI FEATURES

✅ **Gradient AppBar** - Modern cyan-to-blue gradient
✅ **Rounded Cards** - 12px border radius for soft appearance
✅ **Status Badges** - Color-coded (green/red/blue) with icons
✅ **Dynamic Highlighting** - Yellow background with readable text
✅ **Tab Navigation** - Borrower/Book tabs for admin users
✅ **Search Bar** - Rounded with clear button & focus color
✅ **Search History** - Wrap layout with ActionChips
✅ **Advanced Dialog** - Multi-criteria form with date pickers
✅ **Empty States** - Icons + helpful messages for all states
✅ **Cache Indicator** - Green badge shows cached results
✅ **Form Validation** - Minimum 1 criterion required

---

## 🎯 RESPONSIVE LAYOUT

- **Single Column Layout** - Adapts to all screen sizes
- **Flexible Widgets** - Uses Expanded for proper space allocation
- **ListView Builders** - Efficient rendering of large lists
- **SingleChildScrollView** - Prevents overflow on small screens

