import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_supabase_saas_template/services/auth_notifier.dart';
import 'package:flutter_supabase_saas_template/services/metadata_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isAnnualBilling = true;

  @override
  Widget build(BuildContext context) {
    final authNotif = ref.watch(authProvider.notifier);
    final metaAsync = ref.watch(metadataProvider);
    final session = ref.watch(authProvider).value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final userEmail = session?.user.email ?? "founder@startup.io";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.rocket_launch_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Billing & Subscriptions",
            icon: const Icon(Icons.credit_card_rounded),
            onPressed: () => context.pushNamed("payments"),
          ),
          PopupMenuButton<String>(
            tooltip: "User Profile",
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                userEmail[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                authNotif.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text("Logout", style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Welcome Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF312E81), const Color(0xFF1E1B4B)]
                      : [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              "Supabase & Stripe Ready",
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      metaAsync.when(
                        data: (meta) {
                          final sub = meta?.subscription;
                          final planName = sub?.prices?.products?.name ?? "Starter Free";
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              planName.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome back 👋",
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your cross-platform SaaS template is fully configured with live database syncing, role-based access control, and recurring subscriptions.",
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SaaS Analytics / Metrics Grid
            const Text(
              "SaaS Health & Metrics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildMetricCard(
                  title: "Monthly Revenue",
                  value: "\$14,250",
                  growth: "+14.2%",
                  icon: Icons.attach_money_rounded,
                  color: Colors.green,
                ),
                _buildMetricCard(
                  title: "Active Users",
                  value: "1,840",
                  growth: "+8.5%",
                  icon: Icons.people_alt_rounded,
                  color: Colors.blue,
                ),
                _buildMetricCard(
                  title: "API Quota",
                  value: "84.2K",
                  growth: "84% used",
                  icon: Icons.speed_rounded,
                  color: Colors.amber,
                ),
                _buildMetricCard(
                  title: "Database SLA",
                  value: "99.98%",
                  growth: "Optimal",
                  icon: Icons.cloud_done_rounded,
                  color: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Subscription / Pricing Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subscription Plans",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "Monthly",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: !isAnnualBilling ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Switch(
                      value: isAnnualBilling,
                      onChanged: (val) => setState(() => isAnnualBilling = val),
                    ),
                    Text(
                      "Annual (-20%)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isAnnualBilling ? FontWeight.bold : FontWeight.normal,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Pricing Cards
            _buildPricingCard(
              title: "Starter",
              price: isAnnualBilling ? "\$15" : "\$19",
              description: "Best for indie hackers & side projects.",
              features: [
                "Up to 3 team members",
                "10,000 monthly active users",
                "Supabase PostgreSQL + RLS",
                "Community Discord support",
              ],
              isPopular: false,
              onTap: () => context.pushNamed("payments", queryParameters: {"price": "price_starter"}),
            ),
            const SizedBox(height: 12),
            _buildPricingCard(
              title: "Pro (Scale)",
              price: isAnnualBilling ? "\$39" : "\$49",
              description: "Full-scale SaaS with Stripe webhooks & Edge Functions.",
              features: [
                "Unlimited team seats",
                "100,000 monthly active users",
                "Realtime reactive database sync",
                "Custom domain & SSL included",
                "Priority 24/7 technical support",
              ],
              isPopular: true,
              onTap: () => context.pushNamed("payments", queryParameters: {"price": "price_pro"}),
            ),
            const SizedBox(height: 12),
            _buildPricingCard(
              title: "Enterprise",
              price: isAnnualBilling ? "\$159" : "\$199",
              description: "Dedicated instances and custom SLA.",
              features: [
                "Dedicated PostgreSQL cluster",
                "SAML / SSO Authentication",
                "99.99% uptime guarantee",
                "Dedicated customer success manager",
              ],
              isPopular: false,
              onTap: () => context.pushNamed("payments", queryParameters: {"price": "price_enterprise"}),
            ),

            const SizedBox(height: 28),

            // Infrastructure Integrations
            const Text(
              "Integrated Modules",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildIntegrationTile(
              title: "Supabase Auth & Session Refresh",
              subtitle: "Email, Magic Link, Google & Apple OAuth configured",
              icon: Icons.shield_rounded,
              status: "Operational",
            ),
            const SizedBox(height: 8),
            _buildIntegrationTile(
              title: "Stripe Mobile SDK & Edge Webhooks",
              subtitle: "Subscriptions, recurring billing & customer portals",
              icon: Icons.payments_rounded,
              status: "Operational",
            ),
            const SizedBox(height: 8),
            _buildIntegrationTile(
              title: "PostHog Product Analytics",
              subtitle: "Automated funnel tracking and error monitoring",
              icon: Icons.insights_rounded,
              status: "Active",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String growth,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
                Icon(icon, size: 18, color: color),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              growth,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPopular ? theme.colorScheme.primary : theme.dividerColor.withOpacity(0.2),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: isPopular ? 4 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "MOST POPULAR",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.65)),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " / month",
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(f, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: isPopular ? theme.colorScheme.primary : null,
                  foregroundColor: isPopular ? Colors.white : null,
                ),
                child: Text(isPopular ? "Get Started with Pro" : "Choose $title"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntegrationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String status,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
