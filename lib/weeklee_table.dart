import 'package:flutter/material.dart';

/// A customizable and efficient table widget.
///
/// `WeekleeTable` allows dynamic table creation with customizable columns,
/// row decorations, and flexible column widths.
///
/// ### Features:
/// - Supports flexible column widths.
/// - Customizable padding and alignment per column.
/// - Header row with optional decoration.
/// - Data rows with individual styling options.
/// - Default styling including borders and header background.
///
/// Example usage:
/// ```dart
/// WeekleeTable(
///   columns: [
///     WeekleeTableColumn(child: Text('Name'), flex: 2),
///     WeekleeTableColumn(child: Text('Age'), flex: 1),
///   ],
///   rows: [
///     WeekleeTableRow(cells: [Text('Alice'), Text('25')]),
///     WeekleeTableRow(cells: [Text('Bob'), Text('30')]),
///   ],
/// )
/// ```
class WeekleeTable extends StatelessWidget {
  /// Creates a `WeekleeTable` with the specified columns and rows.
  ///
  /// - [columns] defines the table's column structure.
  /// - [rows] defines the table's row content.
  /// - [headerDecoration] applies a custom decoration to the header row.
  /// - [tableBorder] sets the border style for the entire table.
  /// - [columnPadding] defines padding for all columns (default: `EdgeInsets.symmetric(vertical: 8, horizontal: 12)`).
  /// - [columnAlignment] aligns content within each column (default: `Alignment.centerLeft`).
  const WeekleeTable({
    super.key,
    required this.columns,
    required this.rows,
    this.headerDecoration,
    this.tableBorder,
    this.columnPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 12,
    ),
    this.columnAlignment = Alignment.centerLeft,
    this.showCheckBoxes = false,
    this.showHeaderCheckBox = true,
    this.checkboxPadding,
    this.allSelected = false,
    this.onSelectAll,
  });

  /// Default padding applied to all table cells unless overridden per column.
  final EdgeInsets columnPadding;

  /// Default alignment applied to all table cells unless overridden per column.
  final Alignment columnAlignment;

  /// Optional decoration for the table's header row.
  final BoxDecoration? headerDecoration;

  /// List of columns defining the table structure.
  final List<WeekleeTableColumn> columns;

  /// List of rows containing the table's data.
  final List<WeekleeTableRow> rows;

  /// Border styling for the table.
  final TableBorder? tableBorder;

  /// Whether to show checkboxes in the first column.
  final bool showCheckBoxes;

  /// Whether to show checkboxes in the header row.
  final bool showHeaderCheckBox;

  final EdgeInsets? checkboxPadding;

  final bool allSelected;

  final ValueChanged<bool>? onSelectAll;

  @override
  Widget build(BuildContext context) {
    return Table(
      /// Sets the border for the table, defaults to a subtle grey border.
      border: tableBorder ?? TableBorder.all(color: Colors.grey.shade300),

      /// Dynamically assigns column widths based on the `flex` property.
      columnWidths: {
        if (showCheckBoxes) 0: const FixedColumnWidth(40),
        for (var i = 0; i < columns.length; i++)
          i + (showCheckBoxes ? 1 : 0): FlexColumnWidth(
            columns[i].flex?.toDouble() ?? 1,
          ),
      },

      /// Builds the table rows, including the header and data rows.
      children: _buildTableRows(),
    );
  }

  /// Builds the complete list of table rows.
  List<TableRow> _buildTableRows() {
    return [_buildHeaderRow(), ...rows.map(_buildDataRow)];
  }

  /// Builds the header row with optional styling.
  TableRow _buildHeaderRow() {
    return TableRow(
      decoration:
          headerDecoration ?? BoxDecoration(color: Colors.grey.shade200),
      children: [
        if (showCheckBoxes && showHeaderCheckBox)
          Container(
            width: 50,
            padding: checkboxPadding ?? EdgeInsets.zero,
            child: Checkbox(value: allSelected, onChanged: (value) {
              onSelectAll?.call(value ?? false);
            }),
          )
        else if (showCheckBoxes)
          SizedBox(width: 50),
        ...columns.map(
          (column) =>
              _buildCell(column.child, column.padding, column.alignment, null,),
        ),
      ],
    );
  }

  /// Builds a data row with validation for cell count.
  TableRow _buildDataRow(WeekleeTableRow row) {
    if (row.cells.length != columns.length) {
      debugPrint(
        '⚠️ Row has ${row.cells.length} cells, expected ${columns.length}',
      );
    }

    return TableRow(
      decoration: row.decoration,
      children: [
        if (showCheckBoxes)
          Container(
            width: 50,
            padding: checkboxPadding ?? EdgeInsets.zero,
            child: Checkbox(
              value: row.isSelected,
              onChanged: (value) => row.onSelect?.call(value ?? false),
            ),
          ),
        ...List.generate(columns.length, (index) {
          return _buildCell(
            row.cells[index],
            columns[index].padding,
            columns[index].alignment,
            row.onTap,
          );
        }),
      ],
    );
  }

  /// Wraps a cell widget inside a `Container` with proper padding and alignment.
  Widget _buildCell(
    Widget child,
    EdgeInsets? padding,
    Alignment? alignment,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: padding ?? columnPadding,
        alignment: alignment ?? columnAlignment,
        child: child,
      ),
    );
  }
}

/// Defines a column within the `WeekleeTable`.
class WeekleeTableColumn {
  const WeekleeTableColumn({
    this.flex,
    required this.child,
    this.padding,
    this.alignment,
  });

  final int? flex;
  final Widget child;
  final EdgeInsets? padding;
  final Alignment? alignment;
}

/// Defines a row within the `WeekleeTable`.
class WeekleeTableRow {
  const WeekleeTableRow({
    required this.cells,
    this.decoration,
    this.onTap,
    this.isSelected = false,
    this.onSelect,
  });

  /// The list of widgets representing each cell in the row.
  final List<Widget> cells;

  /// Optional decoration for styling the row (e.g., background color).
  final BoxDecoration? decoration;

  /// Callback when the row is tapped.
  final VoidCallback? onTap;

  /// Whether the row is selected (used for checkbox state).
  final bool isSelected;

  /// Callback when the checkbox is toggled.
  final ValueChanged<bool>? onSelect;
}
