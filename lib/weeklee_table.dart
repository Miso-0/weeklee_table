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

  @override
  Widget build(BuildContext context) {
    return Table(
      /// Sets the border for the table, defaults to a subtle grey border.
      border: tableBorder ?? TableBorder.all(color: Colors.grey.shade300),

      /// Dynamically assigns column widths based on the `flex` property.
      columnWidths: {
        for (var i = 0; i < columns.length; i++)
          i: FlexColumnWidth(columns[i].flex?.toDouble() ?? 1),
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
      children:
          columns
              .map(
                (column) =>
                    _buildCell(column.child, column.padding, column.alignment),
              )
              .toList(),
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
      children: List.generate(columns.length, (index) {
        return _buildCell(
          row.cells[index],
          columns[index].padding,
          columns[index].alignment,
        );
      }),
    );
  }

  /// Wraps a cell widget inside a `Container` with proper padding and alignment.
  Widget _buildCell(Widget child, EdgeInsets? padding, Alignment? alignment) {
    return Container(
      padding: padding ?? columnPadding,
      alignment: alignment ?? columnAlignment,
      child: child,
    );
  }
}

/// Defines a column within the `WeekleeTable`.
///
/// Each column can have a custom widget for the header, along with optional
/// padding, alignment, and flexible width.
///
/// Example:
/// ```dart
/// WeekleeTableColumn(
///   child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
///   flex: 2,
///   alignment: Alignment.center,
/// )
/// ```
class WeekleeTableColumn {
  /// Creates a table column with a child widget and optional properties.
  ///
  /// - [child] is the widget displayed in the column header.
  /// - [flex] determines the column's width distribution (default: 1).
  /// - [padding] overrides the default table cell padding.
  /// - [alignment] overrides the default column alignment.
  const WeekleeTableColumn({
    this.flex,
    required this.child,
    this.padding,
    this.alignment,
  });

  /// Determines how much space the column should take relative to other columns.
  final int? flex;

  /// The widget displayed in the column header.
  final Widget child;

  /// Optional padding for cells in this column.
  final EdgeInsets? padding;

  /// Optional alignment for cells in this column.
  final Alignment? alignment;
}

/// Defines a row within the `WeekleeTable`.
///
/// Rows contain a list of widgets (`cells`), and an optional decoration
/// for custom styling.
///
/// Example:
/// ```dart
/// WeekleeTableRow(
///   cells: [Text('Alice'), Text('25')],
///   decoration: BoxDecoration(color: Colors.grey[100]),
/// )
/// ```
class WeekleeTableRow {
  /// Creates a table row with a list of cell widgets.
  ///
  /// - [cells] contains the widgets to be displayed in the row.
  /// - [decoration] allows for custom styling of the row.
  const WeekleeTableRow({required this.cells, this.decoration});

  /// The list of widgets representing each cell in the row.
  final List<Widget> cells;

  /// Optional decoration for styling the row (e.g., background color).
  final BoxDecoration? decoration;
}
