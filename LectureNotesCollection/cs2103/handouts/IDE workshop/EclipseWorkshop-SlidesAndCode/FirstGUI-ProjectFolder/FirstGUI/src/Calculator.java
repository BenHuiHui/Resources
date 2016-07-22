import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.forms.widgets.FormToolkit;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FormLayout;
import org.eclipse.swt.layout.FormData;
import org.eclipse.swt.layout.FormAttachment;


public class Calculator extends Composite implements SelectionListener{

	private final FormToolkit toolkit = new FormToolkit(Display.getCurrent());
	private Label lblNewLabel;

	/**
	 * Create the composite.
	 * @param parent
	 * @param style
	 */
	public Calculator(Composite parent, int style) {
		super(parent, style);
		addDisposeListener(new DisposeListener() {
			public void widgetDisposed(DisposeEvent e) {
				toolkit.dispose();
			}
		});
		toolkit.adapt(this);
		toolkit.paintBordersFor(this);
		setLayout(new FormLayout());
		
		lblNewLabel = new Label(this, SWT.NONE);
		lblNewLabel.setAlignment(SWT.RIGHT);
		FormData fd_lblNewLabel = new FormData();
		fd_lblNewLabel.left = new FormAttachment(0, 10);
		fd_lblNewLabel.top = new FormAttachment(0, 10);
		fd_lblNewLabel.bottom = new FormAttachment(0, 40);
		lblNewLabel.setLayoutData(fd_lblNewLabel);
		toolkit.adapt(lblNewLabel, true, true);
		lblNewLabel.setText("0");
		
		Composite composite = new Composite(this, SWT.NONE);
		fd_lblNewLabel.right = new FormAttachment(composite, 0, SWT.RIGHT);
		composite.setLayout(new GridLayout(4, false));
		FormData fd_composite = new FormData();
		fd_composite.top = new FormAttachment(lblNewLabel, 10);
		fd_composite.bottom = new FormAttachment(100, -10);
		fd_composite.right = new FormAttachment(100, -10);
		fd_composite.left = new FormAttachment(0, 10);
		composite.setLayoutData(fd_composite);
		toolkit.adapt(composite);
		toolkit.paintBordersFor(composite);
		
		Button btnNewButton = new Button(composite, SWT.NONE);
		btnNewButton.addSelectionListener(this);
		/*
		btnNewButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				Button b = (Button)e.getSource();
				int num = Integer.parseInt(lblNewLabel.getText());
				num += Integer.parseInt(b.getText());
				lblNewLabel.setText(num+"");
			}
		});
		*/
		GridData gd_btnNewButton = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton.widthHint = 60;
		btnNewButton.setLayoutData(gd_btnNewButton);
		toolkit.adapt(btnNewButton, true, true);
		btnNewButton.setText("1");
		
		Button btnNewButton_1 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_1 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_1.widthHint = 60;
		btnNewButton_1.setLayoutData(gd_btnNewButton_1);
		toolkit.adapt(btnNewButton_1, true, true);
		btnNewButton_1.setText("2");
		
		Button btnNewButton_2 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_2 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_2.widthHint = 60;
		btnNewButton_2.setLayoutData(gd_btnNewButton_2);
		toolkit.adapt(btnNewButton_2, true, true);
		btnNewButton_2.setText("3");
		
		Button btnNewButton_3 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_3 = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1);
		gd_btnNewButton_3.widthHint = 60;
		btnNewButton_3.setLayoutData(gd_btnNewButton_3);
		toolkit.adapt(btnNewButton_3, true, true);
		btnNewButton_3.setText("+");
		
		Button btnNewButton_4 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_4 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_4.widthHint = 60;
		btnNewButton_4.setLayoutData(gd_btnNewButton_4);
		toolkit.adapt(btnNewButton_4, true, true);
		btnNewButton_4.setText("4");
		
		Button btnNewButton_5 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_5 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_5.widthHint = 60;
		btnNewButton_5.setLayoutData(gd_btnNewButton_5);
		toolkit.adapt(btnNewButton_5, true, true);
		btnNewButton_5.setText("5");
		
		Button btnNewButton_6 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_6 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_6.widthHint = 60;
		btnNewButton_6.setLayoutData(gd_btnNewButton_6);
		toolkit.adapt(btnNewButton_6, true, true);
		btnNewButton_6.setText("6");
		
		Button btnNewButton_7 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_7 = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1);
		gd_btnNewButton_7.widthHint = 60;
		btnNewButton_7.setLayoutData(gd_btnNewButton_7);
		toolkit.adapt(btnNewButton_7, true, true);
		btnNewButton_7.setText("-");
		
		Button btnNewButton_8 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_8 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_8.widthHint = 60;
		btnNewButton_8.setLayoutData(gd_btnNewButton_8);
		toolkit.adapt(btnNewButton_8, true, true);
		btnNewButton_8.setText("7");
		
		Button btnNewButton_9 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_9 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_9.widthHint = 60;
		btnNewButton_9.setLayoutData(gd_btnNewButton_9);
		toolkit.adapt(btnNewButton_9, true, true);
		btnNewButton_9.setText("8");
		
		Button btnNewButton_10 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_10 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_10.widthHint = 60;
		btnNewButton_10.setLayoutData(gd_btnNewButton_10);
		toolkit.adapt(btnNewButton_10, true, true);
		btnNewButton_10.setText("9");
		
		Button btnNewButton_11 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_11 = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1);
		gd_btnNewButton_11.widthHint = 60;
		btnNewButton_11.setLayoutData(gd_btnNewButton_11);
		toolkit.adapt(btnNewButton_11, true, true);
		btnNewButton_11.setText("*");
		
		Button btnNewButton_12 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_12 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_12.widthHint = 60;
		btnNewButton_12.setLayoutData(gd_btnNewButton_12);
		toolkit.adapt(btnNewButton_12, true, true);
		btnNewButton_12.setText(".");
		
		Button btnNewButton_13 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_13 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_13.widthHint = 60;
		btnNewButton_13.setLayoutData(gd_btnNewButton_13);
		toolkit.adapt(btnNewButton_13, true, true);
		btnNewButton_13.setText("0");
		
		Button btnNewButton_14 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_14 = new GridData(SWT.LEFT, SWT.CENTER, false, false, 1, 1);
		gd_btnNewButton_14.widthHint = 60;
		btnNewButton_14.setLayoutData(gd_btnNewButton_14);
		toolkit.adapt(btnNewButton_14, true, true);
		btnNewButton_14.setText("=");
		
		Button btnNewButton_15 = new Button(composite, SWT.NONE);
		GridData gd_btnNewButton_15 = new GridData(SWT.LEFT, SWT.CENTER, true, false, 1, 1);
		gd_btnNewButton_15.widthHint = 60;
		btnNewButton_15.setLayoutData(gd_btnNewButton_15);
		toolkit.adapt(btnNewButton_15, true, true);
		btnNewButton_15.setText("/");
		
		btnNewButton_1.addSelectionListener(this);
		btnNewButton_2.addSelectionListener(this);
		btnNewButton_4.addSelectionListener(this);
		btnNewButton_5.addSelectionListener(this);
		btnNewButton_6.addSelectionListener(this);
		btnNewButton_8.addSelectionListener(this);
		btnNewButton_9.addSelectionListener(this);
		btnNewButton_10.addSelectionListener(this);
	}
	
	public static void main(String[] args){	
		Display display = new Display();
		Shell shell = new Shell(display);
		Calculator calc = new Calculator(shell, SWT.NONE);
		
		calc.pack();
		shell.pack();
		shell.open();
		while(!shell.isDisposed()){
			if(!display.readAndDispatch()) display.sleep();
		}
	}

	@Override
	public void widgetDefaultSelected(SelectionEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void widgetSelected(SelectionEvent e) {
		// TODO Auto-generated method stub
		Button b = (Button)e.getSource();
		int num = Integer.parseInt(lblNewLabel.getText());
		num += Integer.parseInt(b.getText());
		lblNewLabel.setText(num+"");
	}	
}
