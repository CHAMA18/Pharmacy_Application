import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmay_application/theme.dart';
import 'package:pharmay_application/nav.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          if (isDesktop)
            _AdminSidebar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _AdminAppBar(isDesktop: isDesktop),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(_buildSelectedContent(context)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: !isDesktop
          ? Drawer(
              child: _AdminSidebar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context); // Close drawer
                },
              ),
            )
          : null,
    );
  }

  List<Widget> _buildSelectedContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent(context);
      case 1:
        return _buildInventoryContent(context);
      case 2:
        return _buildOrdersContent(context);
      case 3:
        return _buildPatientsContent(context);
      case 4:
        return _buildAnalyticsContent(context);
      case 5:
        return _buildSettingsContent(context);
      default:
        return _buildDashboardContent(context);
    }
  }

  Widget _pageHeader({required String title, required String subtitle, Widget? action}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildStatCardsRow({required double constraintsMax, List<_StatCard>? customCards}) {
    final isMobile = constraintsMax < 600;
    final crossAxisCount = isMobile ? 1 : (constraintsMax < 1100 ? 2 : 4);
    final cards = customCards ?? const [
      _StatCard(title: 'Total Revenue', value: '\$124,563.00', trend: '+12.5%', isPositive: true, icon: Icons.attach_money_rounded, gradientColors: [Color(0xFF4CA1AF), Color(0xFFC4E0E5)]),
      _StatCard(title: 'Active Orders', value: '1,245', trend: '+5.2%', isPositive: true, icon: Icons.shopping_bag_rounded, gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
      _StatCard(title: 'Total Patients', value: '8,392', trend: '-2.1%', isPositive: false, icon: Icons.people_alt_rounded, gradientColors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)]),
      _StatCard(title: 'Low Stock Items', value: '14', trend: '+4.0%', isPositive: false, icon: Icons.inventory_2_rounded, gradientColors: [Color(0xFFFA709A), Color(0xFFFEE140)]),
    ];
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: isMobile ? 2.5 : 1.8,
      children: cards,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 900;
      if (isDesktop) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: _buildRevenueChart(context)),
          const SizedBox(width: 24),
          Expanded(flex: 1, child: _buildRecentOrders(context)),
        ]);
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildRevenueChart(context),
        const SizedBox(height: 24),
        _buildRecentOrders(context),
      ]);
    });
  }

  List<Widget> _buildDashboardContent(BuildContext context) {
    final theme = Theme.of(context);
    return [
      const SizedBox(height: 16),
      _pageHeader(
        title: 'Dashboard Overview',
        subtitle: 'Welcome back! Here\'s what\'s happening today.',
        action: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, size: 20, color: theme.colorScheme.onPrimary),
              const SizedBox(width: 8),
              Text('Export Report', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 32),
      _buildStatCardsRow(constraintsMax: MediaQuery.of(context).size.width),
      const SizedBox(height: 32),
      _buildMainContent(context),
      const SizedBox(height: 48),
    ];
  }

  List<Widget> _buildInventoryContent(BuildContext context) {
    final theme = Theme.of(context);
    final cards = [
      const _StatCard(title: 'Total SKUs', value: '3,428', trend: '+6.2%', isPositive: true, icon: Icons.inventory_2_rounded, gradientColors: [Color(0xFF4CA1AF), Color(0xFF2C3E50)]),
      const _StatCard(title: 'Low Stock', value: '27', trend: '+3.1%', isPositive: false, icon: Icons.warning_amber_rounded, gradientColors: [Color(0xFFFF758C), Color(0xFFFF7EB3)]),
      const _StatCard(title: 'Out of Stock', value: '5', trend: '-1.2%', isPositive: true, icon: Icons.block_rounded, gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
      const _StatCard(title: 'New Shipments', value: '12', trend: '+4.8%', isPositive: true, icon: Icons.local_shipping_rounded, gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
    ];
    final items = [
      {'name': 'Amoxicillin 500mg Capsules', 'sku': 'RX-1045', 'stock': '320 units', 'status': 'Stable', 'supplier': 'HealthCorp', 'color': Colors.green},
      {'name': 'Ibuprofen 200mg Tablets', 'sku': 'RX-0831', 'stock': '95 units', 'status': 'Low', 'supplier': 'MediSupplies', 'color': Colors.orange},
      {'name': 'Insulin Glargine 10ml', 'sku': 'RX-2018', 'stock': '12 units', 'status': 'Critical', 'supplier': 'CarePlus', 'color': Colors.redAccent},
      {'name': 'Cetrizine 10mg Tablets', 'sku': 'RX-0173', 'stock': '540 units', 'status': 'Stable', 'supplier': 'PharmaMax', 'color': Colors.green},
      {'name': 'Saline IV 500ml', 'sku': 'RX-3341', 'stock': '61 units', 'status': 'Low', 'supplier': 'Wellness Co.', 'color': Colors.orange},
    ];
    return [
      const SizedBox(height: 16),
      _pageHeader(
        title: 'Inventory Control',
        subtitle: 'Precision-tracked stock with proactive alerts.',
        action: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(24)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_rounded, size: 20, color: theme.colorScheme.onPrimary), const SizedBox(width: 8), Text('Add New Item', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600))]),
        ),
      ),
      const SizedBox(height: 24),
      _buildStatCardsRow(constraintsMax: MediaQuery.of(context).size.width, customCards: cards),
      const SizedBox(height: 24),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1100;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(theme),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Live Inventory', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Wrap(spacing: 8, children: [
                  _tag(theme, 'All'),
                  _tag(theme, 'Low Stock', color: Colors.orange),
                  _tag(theme, 'Critical', color: Colors.redAccent),
                  _tag(theme, 'Expiring Soon', color: theme.colorScheme.primary),
                ]),
              ]),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(children: [
                      Container(width: 46, height: 46, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.medication_rounded, color: theme.colorScheme.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item['name'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        Text('${item['sku']} • ${item['supplier']}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ])),
                      _statusPill(item['status'] as String, item['color'] as Color, theme),
                      const SizedBox(width: 12),
                      Text(item['stock'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                    ]),
                  );
                },
              ),
            ]),
          )),
          const SizedBox(width: 20),
          Expanded(flex: isWide ? 2 : 0, child: isWide ? Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _panelDecoration(theme),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Low Stock Alerts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...[
                  {'title': 'Insulin Glargine 10ml', 'level': '12 units left', 'color': Colors.redAccent},
                  {'title': 'Ibuprofen 200mg Tablets', 'level': '95 units left', 'color': Colors.orange},
                  {'title': 'Saline IV 500ml', 'level': '61 units left', 'color': Colors.orange},
                ].map((alert) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: (alert['color'] as Color).withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Icon(Icons.error_outline_rounded, color: alert['color'] as Color),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(alert['title'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(alert['level'] as String, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ])),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  ]),
                )),
              ]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _panelDecoration(theme),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Reorder Suggestions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...['Vitamin C 500mg • Order 250 units', 'Paracetamol 500mg • Order 500 units', 'Blood Pressure Cuffs • Order 40 units']
                    .map((text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
                          Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
                        ]))),
              ]),
            ),
          ]) : const SizedBox.shrink()),
        ]);
      }),
      const SizedBox(height: 36),
    ];
  }

  List<Widget> _buildOrdersContent(BuildContext context) {
    final theme = Theme.of(context);
    final orders = [
      {'id': '#1028', 'time': '2 mins ago', 'status': 'Processing', 'color': Colors.orange, 'total': '\$240.40'},
      {'id': '#1027', 'time': '5 mins ago', 'status': 'Delivered', 'color': Colors.green, 'total': '\$328.10'},
      {'id': '#1026', 'time': '8 mins ago', 'status': 'Cancelled', 'color': Colors.redAccent, 'total': '\$158.00'},
      {'id': '#1025', 'time': '10 mins ago', 'status': 'Processing', 'color': Colors.orange, 'total': '\$191.30'},
      {'id': '#1024', 'time': '15 mins ago', 'status': 'Delivered', 'color': Colors.green, 'total': '\$259.90'},
    ];
    return [
      const SizedBox(height: 16),
      _pageHeader(
        title: 'Orders',
        subtitle: 'Command the fulfillment pipeline with live insights.',
        action: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(24)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.download_rounded, size: 20, color: theme.colorScheme.onPrimary), const SizedBox(width: 8), Text('Export', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600))]),
        ),
      ),
      const SizedBox(height: 24),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1100;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(theme),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Recent Orders', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Wrap(spacing: 8, children: [
                  _tag(theme, 'All'),
                  _tag(theme, 'Delivered', color: Colors.green),
                  _tag(theme, 'Processing', color: Colors.orange),
                  _tag(theme, 'Cancelled', color: Colors.redAccent),
                ]),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(child: Text('Order ID', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700))),
                  Expanded(child: Text('Timeline', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700))),
                  Expanded(child: Text('Status', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700))),
                  Expanded(child: Text('Total', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.end)),
                ]),
              ),
              const SizedBox(height: 4),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.08)))),
                    child: Row(children: [
                      Expanded(child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.receipt_long_rounded, color: theme.colorScheme.primary)), const SizedBox(width: 10), Text(order['id'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))])),
                      Expanded(child: Text(order['time'] as String, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                      Expanded(child: Align(alignment: Alignment.centerLeft, child: _statusPill(order['status'] as String, order['color'] as Color, theme))),
                      Expanded(child: Text(order['total'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
                    ]),
                  );
                },
              ),
            ]),
          )),
          const SizedBox(width: 20),
          if (isWide)
            Expanded(flex: 2, child: Container(
              padding: const EdgeInsets.all(20),
              decoration: _panelDecoration(theme),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Delivery Pulse', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _metricRow(theme, 'Avg. Processing Time', '1h 12m', Icons.timer_rounded, theme.colorScheme.primary),
                const SizedBox(height: 8),
                _metricRow(theme, 'On-Time Rate', '96%', Icons.speed_rounded, Colors.green),
                const SizedBox(height: 8),
                _metricRow(theme, 'Returns', '2.1%', Icons.undo_rounded, Colors.orange),
                const SizedBox(height: 16),
                Text('Fulfillment Insights', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...['Optimize cold-chain shipments', 'Prioritize low-stock substitutions', 'Auto-alert courier delays'].map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 18), const SizedBox(width: 8), Expanded(child: Text(e, style: theme.textTheme.bodyMedium))]))),
              ]),
            )),
        ]);
      }),
      const SizedBox(height: 36),
    ];
  }

  List<Widget> _buildPatientsContent(BuildContext context) {
    final theme = Theme.of(context);
    final patients = [
      {'name': 'Sophia Turner', 'id': 'MT-4821', 'status': 'Stable', 'color': Colors.green, 'plan': 'Diabetes Care', 'lastVisit': 'Today'},
      {'name': 'Daniel Lee', 'id': 'MT-3792', 'status': 'Follow-up', 'color': Colors.orange, 'plan': 'Cardio Rehab', 'lastVisit': 'Yesterday'},
      {'name': 'Amelia Chen', 'id': 'MT-2145', 'status': 'Critical', 'color': Colors.redAccent, 'plan': 'ICU Recovery', 'lastVisit': '2 days ago'},
      {'name': 'Michael Green', 'id': 'MT-1409', 'status': 'Stable', 'color': Colors.green, 'plan': 'General Care', 'lastVisit': '1 week ago'},
    ];
    return [
      const SizedBox(height: 16),
      _pageHeader(title: 'Patients', subtitle: 'Care-first intelligence with every profile.'),
      const SizedBox(height: 24),
      _buildStatCardsRow(constraintsMax: MediaQuery.of(context).size.width, customCards: const [
        _StatCard(title: 'Active Patients', value: '8,392', trend: '+3.4%', isPositive: true, icon: Icons.favorite_rounded, gradientColors: [Color(0xFF00C6FF), Color(0xFF0072FF)]),
        _StatCard(title: 'Follow-ups', value: '184', trend: '+1.2%', isPositive: true, icon: Icons.autorenew_rounded, gradientColors: [Color(0xFFFFB75E), Color(0xFFED8F03)]),
        _StatCard(title: 'Critical', value: '26', trend: '-0.8%', isPositive: true, icon: Icons.emergency_rounded, gradientColors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
        _StatCard(title: 'Satisfaction', value: '4.9/5', trend: '+0.2%', isPositive: true, icon: Icons.star_rate_rounded, gradientColors: [Color(0xFF56CCF2), Color(0xFF2F80ED)]),
      ]),
      const SizedBox(height: 24),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1050;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(theme),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Patient Roster', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                _tag(theme, 'Smart Filters', color: theme.colorScheme.primary),
              ]),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(children: [
                      CircleAvatar(radius: 24, backgroundColor: theme.colorScheme.primaryContainer, child: Icon(Icons.person_rounded, color: theme.colorScheme.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(patient['name'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('${patient['id']} • ${patient['plan']}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        _statusPill(patient['status'] as String, patient['color'] as Color, theme),
                        const SizedBox(height: 6),
                        Text('Last visit: ${patient['lastVisit']}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ]),
                    ]),
                  );
                },
              ),
            ]),
          )),
          const SizedBox(width: 20),
          if (isWide)
            Expanded(flex: 2, child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Upcoming Appointments', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...[
                    {'title': 'Cardio Follow-up', 'time': 'Today • 2:00 PM', 'person': 'Daniel Lee'},
                    {'title': 'Diabetes Coaching', 'time': 'Today • 4:30 PM', 'person': 'Sophia Turner'},
                    {'title': 'Post-Op Review', 'time': 'Tomorrow • 10:00 AM', 'person': 'Amelia Chen'},
                  ].map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          Icon(Icons.event_available_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['title'] as String, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)), Text(item['time'] as String, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))])),
                          Text(item['person'] as String, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        ]),
                      )),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Care Insights', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...['98% treatment adherence this week', 'Patients waiting time reduced to 6 mins', 'Telehealth satisfaction at 4.8/5'].map((text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(Icons.trending_up_rounded, color: theme.colorScheme.primary, size: 18), const SizedBox(width: 8), Expanded(child: Text(text, style: theme.textTheme.bodyMedium))]))),
                ]),
              ),
            ])),
        ]);
      }),
      const SizedBox(height: 36),
    ];
  }

  List<Widget> _buildAnalyticsContent(BuildContext context) {
    final theme = Theme.of(context);
    return [
      const SizedBox(height: 16),
      _pageHeader(
        title: 'Analytics',
        subtitle: 'Command center for performance, growth, and precision.',
        action: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(24)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.auto_graph_rounded, size: 20, color: theme.colorScheme.onPrimary), const SizedBox(width: 8), Text('Create Report', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600))]),
        ),
      ),
      const SizedBox(height: 24),
      _buildStatCardsRow(constraintsMax: MediaQuery.of(context).size.width, customCards: const [
        _StatCard(title: 'Revenue (MTD)', value: '\$124,563', trend: '+8.4%', isPositive: true, icon: Icons.show_chart_rounded, gradientColors: [Color(0xFF56CCF2), Color(0xFF2F80ED)]),
        _StatCard(title: 'Conversion', value: '62%', trend: '+2.1%', isPositive: true, icon: Icons.bolt_rounded, gradientColors: [Color(0xFFFFAFBD), Color(0xFFFFC3A0)]),
        _StatCard(title: 'Churn', value: '1.4%', trend: '-0.3%', isPositive: true, icon: Icons.autorenew_rounded, gradientColors: [Color(0xFFB24592), Color(0xFFF15F79)]),
        _StatCard(title: 'Avg. Order Value', value: '\$148.20', trend: '+3.7%', isPositive: true, icon: Icons.payments_rounded, gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
      ]),
      const SizedBox(height: 24),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1050;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: Container(
            padding: const EdgeInsets.all(20),
            height: 420,
            decoration: _panelDecoration(theme),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Performance Trends', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                _tag(theme, 'Last 12 weeks', color: theme.colorScheme.primary),
              ]),
              const SizedBox(height: 12),
              Expanded(child: LineChart(LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 12,
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2, getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.outline.withValues(alpha: 0.08), strokeWidth: 1, dashArray: [5, 5])),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 2, reservedSize: 40, getTitlesWidget: (value, meta) => Text('${value.toInt()}k', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 2, getTitlesWidget: (value, meta) {const labels = ['W1','W2','W3','W4','W5','W6','W7','W8','W9','W10','W11','W12']; return Text(labels[value.toInt()], style: TextStyle(color: theme.colorScheme.onSurfaceVariant));})),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(spots: const [FlSpot(0, 6), FlSpot(1, 5.5), FlSpot(2, 7), FlSpot(3, 8.2), FlSpot(4, 7.8), FlSpot(5, 9), FlSpot(6, 8.6), FlSpot(7, 9.4), FlSpot(8, 10.1), FlSpot(9, 9.8), FlSpot(10, 11), FlSpot(11, 10.6)], isCurved: true, color: theme.colorScheme.primary, barWidth: 4, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withValues(alpha: 0.12))),
                  LineChartBarData(spots: const [FlSpot(0, 4.5), FlSpot(1, 4.8), FlSpot(2, 5.2), FlSpot(3, 5.7), FlSpot(4, 5.5), FlSpot(5, 6.1), FlSpot(6, 6.4), FlSpot(7, 6.9), FlSpot(8, 7.2), FlSpot(9, 7.1), FlSpot(10, 7.6), FlSpot(11, 7.9)], isCurved: true, color: Colors.purpleAccent, barWidth: 4, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: Colors.purpleAccent.withValues(alpha: 0.1))),
                ],
              ))),
            ]),
          )),
          const SizedBox(width: 20),
          if (isWide)
            Expanded(flex: 2, child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Snapshot', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _metricRow(theme, 'Top Region', 'San Francisco', Icons.place_rounded, theme.colorScheme.primary),
                  const SizedBox(height: 6),
                  _metricRow(theme, 'Best Channel', 'Direct • 42%', Icons.explore_rounded, Colors.green),
                  const SizedBox(height: 6),
                  _metricRow(theme, 'Avg. Session', '6m 21s', Icons.timer_rounded, Colors.orange),
                  const SizedBox(height: 16),
                  Text('Opportunities', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...['Launch proactive refill nudges', 'Accelerate loyalty rewards for top 5%', 'Scale telehealth cross-sell'].map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 18), const SizedBox(width: 8), Expanded(child: Text(e, style: theme.textTheme.bodyMedium))]))),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Conversion Funnel', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...[
                    {'step': 'Sessions', 'value': '18,240', 'pct': 100},
                    {'step': 'Product Views', 'value': '12,780', 'pct': 70},
                    {'step': 'Cart Adds', 'value': '7,520', 'pct': 41},
                    {'step': 'Checkouts', 'value': '4,220', 'pct': 23},
                    {'step': 'Purchases', 'value': '2,960', 'pct': 16},
                  ].map((funnel) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(funnel['step'] as String, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)), Text(funnel['value'] as String, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))]),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (funnel['pct'] as int) / 100,
                              minHeight: 10,
                              color: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                            ),
                          ),
                        ]),
                      )),
                ]),
              ),
            ])),
        ]);
      }),
      const SizedBox(height: 36),
    ];
  }

  List<Widget> _buildSettingsContent(BuildContext context) {
    final theme = Theme.of(context);
    return [
      const SizedBox(height: 16),
      _pageHeader(title: 'Settings', subtitle: 'Fine-tuned controls for a flawless operation.'),
      const SizedBox(height: 24),
      LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(theme),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Profile & Security', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _settingsRow(theme, 'Full Name', 'Dr. Alexandra Hughes'),
              _settingsRow(theme, 'Role', 'Chief Medical Officer'),
              _settingsRow(theme, 'Email', 'alexandra@meditracker.com'),
              const SizedBox(height: 12),
              _toggleRow(theme, 'Two-Factor Authentication', true),
              _toggleRow(theme, 'Login alerts', true),
              _toggleRow(theme, 'Session timeout reminders', false),
            ]),
          )),
          const SizedBox(width: 20),
          if (isWide)
            Expanded(flex: 2, child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Experience', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _toggleRow(theme, 'Desktop-optimized layouts', true),
                  _toggleRow(theme, 'Reduce motion for patients', false),
                  _toggleRow(theme, 'Dark mode auto-schedule', true),
                  const SizedBox(height: 12),
                  Text('Notification Channels', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...['Email', 'SMS', 'Push', 'Slack'].map((channel) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Icon(Icons.notifications_active_rounded, color: theme.colorScheme.primary, size: 18), const SizedBox(width: 8), Text(channel, style: theme.textTheme.bodyMedium)]))),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(theme),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Data & Compliance', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...['HIPAA alignment confirmed', 'Audit logs retained for 2 years', 'Backups replicated hourly'].map((text) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 18), const SizedBox(width: 8), Expanded(child: Text(text, style: theme.textTheme.bodyMedium))]))),
                ]),
              ),
            ])),
        ]);
      }),
      const SizedBox(height: 36),
    ];
  }

  BoxDecoration _panelDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
      ],
    );
  }

  Widget _tag(ThemeData theme, String text, {Color? color}) {
    final tint = color ?? theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: tint.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: theme.textTheme.labelMedium?.copyWith(color: tint, fontWeight: FontWeight.w700)),
    );
  }

  Widget _statusPill(String text, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, size: 10, color: color), const SizedBox(width: 6), Text(text, style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _metricRow(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
      const SizedBox(width: 10),
      Expanded(child: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
      Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _settingsRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _toggleRow(ThemeData theme, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Switch(value: value, onChanged: (_) {}, activeColor: theme.colorScheme.primary),
      ]),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Analytics',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'This Week',
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    items: ['This Week', 'This Month', 'This Year']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (_) {},
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('Mon', style: style); break;
                          case 1: text = const Text('Tue', style: style); break;
                          case 2: text = const Text('Wed', style: style); break;
                          case 3: text = const Text('Thu', style: style); break;
                          case 4: text = const Text('Fri', style: style); break;
                          case 5: text = const Text('Sat', style: style); break;
                          case 6: text = const Text('Sun', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return SideTitleWidget(axisSide: meta.axisSide, child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toInt()}k', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3), FlSpot(1, 2.5), FlSpot(2, 4), FlSpot(3, 3.8),
                      FlSpot(4, 5.2), FlSpot(5, 4.5), FlSpot(6, 5.8),
                    ],
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
            itemBuilder: (context, index) {
              final statuses = ['Delivered', 'Processing', 'Cancelled', 'Delivered', 'Processing'];
              final colors = [Colors.green, Colors.orange, Colors.red, Colors.green, Colors.orange];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.receipt_rounded, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #${1024 + index}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          Text('2 mins ago', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors[index].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        statuses[index],
                        style: theme.textTheme.labelSmall?.copyWith(color: colors[index], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _AdminSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // App Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Meditracker',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _AdminSidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                _AdminSidebarItem(
                  icon: Icons.inventory_2_rounded,
                  label: 'Inventory',
                  isSelected: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
                _AdminSidebarItem(
                  icon: Icons.shopping_bag_rounded,
                  label: 'Orders',
                  isSelected: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
                _AdminSidebarItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Patients',
                  isSelected: selectedIndex == 3,
                  onTap: () => onDestinationSelected(3),
                ),
                _AdminSidebarItem(
                  icon: Icons.analytics_rounded,
                  label: 'Analytics',
                  isSelected: selectedIndex == 4,
                  onTap: () => onDestinationSelected(4),
                ),
                _AdminSidebarItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: selectedIndex == 5,
                  onTap: () => onDestinationSelected(5),
                ),
              ],
            ),
          ),
          // Bottom section
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            child: _AdminSidebarItem(
              icon: Icons.arrow_back_rounded,
              label: 'Back to App',
              isSelected: false,
              onTap: () => context.go(AppRoutes.dashboard),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdminSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final IconData icon;
  final List<Color> gradientColors;

  const _StatCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors.map((c) => c.withValues(alpha: 0.8)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.redAccent).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminAppBar extends StatelessWidget {
  final bool isDesktop;

  const _AdminAppBar({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      floating: true,
      pinned: true,
      leading: !isDesktop
          ? IconButton(
              icon: Icon(Icons.menu_rounded, color: theme.colorScheme.onSurface),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : const SizedBox.shrink(),
      leadingWidth: !isDesktop ? 56 : 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              // Search
              Container(
                width: 250,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search anything...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Notifications
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Profile
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.person_rounded, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
