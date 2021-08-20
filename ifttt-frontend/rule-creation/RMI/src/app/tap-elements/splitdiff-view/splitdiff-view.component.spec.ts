import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SplitdiffViewComponent } from './splitdiff-view.component';

describe('SplitdiffViewComponent', () => {
  let component: SplitdiffViewComponent;
  let fixture: ComponentFixture<SplitdiffViewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SplitdiffViewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SplitdiffViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
